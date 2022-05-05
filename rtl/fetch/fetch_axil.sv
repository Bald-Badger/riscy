// Seriously, this code is a shit-whole
// Rewrite this mudule with better FSM in the future

import defines::*;
import axi_defines::*;

module fetch_axil # (
	parameter INSTR_QUE_ADDR_WIDTH = 4
) (
	// general input
	input	logic					clk, 
	input	logic					rst_n,

	// input
	input	data_t					pc_bj,
	input 	logic					pc_sel,
	input 	logic					stall,
	input	logic					flush,
	input	logic					go,
	input	logic [9:0]				boot_pc_extrn,
	input	instr_t					instr_w,

	// output
	output	data_t					pc_out,
	output	instr_t					instr,
	output	logic					instr_valid,

	// AXI Lite bus interface
	axil_interface.axil_master		axil_bus
);

	// state explained in latter FSM logic
	typedef enum logic[2:0] {
		DEBUG,
		FETCH,
		STALL,
		EBREAK_WAIT
	} state_t;

	state_t state, nxt_state;

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			state <= DEBUG;
		else
			state <= nxt_state;
	end

	typedef struct packed {
		data_t	instr;
		data_t	pc;
	} instr_queue_entry_t;

	logic [INSTR_QUE_ADDR_WIDTH:0] fifo_counter;
	logic ebreak, ebreak_clear;
	logic done;
	
	logic buf_empty, buf_full, buf_almost_full;

	logic ifu_rden;
	logic ifu_valid;

	// pc control logic
	data_t pc, pc_p4;

	assign pc_p4 = pc + 32'd4;

	logic pc_en;
	logic update_pc;
	assign update_pc = done;

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			pc_en <= CLEAR;
		else if (go)
			pc_en <= SET;
		else if (state == EBREAK_WAIT)
			pc_en <= CLEAR;
		else if (state == DEBUG)
			pc_en <= CLEAR;
		else
			pc_en <= pc_en;
	end


	data_t pc_nxt, pc_bj_ff;
	logic flush_flag, flush_flag_delay;

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			flush_flag <= CLEAR;
		else if (flush && ~done)
			flush_flag <= SET;
		else if (done)
			flush_flag <= CLEAR;
		else
			flush_flag <= flush_flag;
	end

	always_ff @(posedge clk) begin
		flush_flag_delay <= flush_flag;
	end

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			pc_bj_ff <= NULL;
		else if (pc_sel)
			pc_bj_ff <= pc_bj;
		else
			pc_bj_ff <= pc_bj_ff;
	end


	always_comb begin
		if (done && flush)
			pc_nxt = pc_bj;
		else
			pc_nxt = flush_flag ? pc_bj_ff : pc_p4;
	end


	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			pc <= (boot_pc_extrn * 4);
		end else if (pc_en && update_pc) begin
			pc <= pc_nxt;
		end else begin
			pc <= pc;
		end
	end
	// end pc control logic


	// instruction wires
	instr_queue_entry_t instr_fifo_in, instr_fifo_out;
	data_t instr_mem_sys;
	data_t instr_plain;
	data_t instr_switch;	// switch endianess
	logic instr_valid_early;
	assign instr_plain = data_t'(instr_mem_sys);
	assign instr_fifo_in = instr_queue_entry_t'({instr_mem_sys, pc});
	// BUG: assert ebreak = instr_d == EBREAK
	assign ebreak = (instr_plain == EBREAK);
	assign ebreak_clear = (data_t'(instr_w) == EBREAK);
	assign instr_valid_early = ((~buf_empty) && (~stall) && (~flush) && (~flush_flag) && (~flush_flag_delay));
	// end instruction wires

	data_t instr_debug;
	assign instr_debug = data_t'(instr);

	// delay instr_valid for one cycle because fifo have 1 cycle read delay
	always_ff @( posedge clk, negedge rst_n ) begin
		if (~rst_n)
			instr_valid <= 1'b0;
		else if (flush)
			instr_valid <= 1'b0;
		else if (flush_flag_delay)
			instr_valid <= 1'b0;
		else if (stall)
			instr_valid <=instr_valid;
		else
			instr_valid <= instr_valid_early;
	end


	always_comb begin
		nxt_state			= DEBUG;
		ifu_rden			= DISABLE;
		ifu_valid			= INVALID;
		unique case (state)

			// init state, the CPU stall due to a EBREAK instruction
			// hand over the control flow to debugger
			DEBUG: begin
				if (go) begin
					nxt_state	= FETCH;
				end else begin
					nxt_state	= DEBUG;
				end
			end

			FETCH: begin
					ifu_rden = ENABLE;
					ifu_valid = VALID;
				if (done && buf_almost_full) begin
					nxt_state	= STALL;
				end else if (done && ebreak) begin
					nxt_state	= EBREAK_WAIT;
				end else begin
					nxt_state	= FETCH;
				end
			end

			// instruction issue almoat full, stall fetch
			STALL: begin
				if (~buf_almost_full) begin
					nxt_state	= FETCH;
				end else begin
					nxt_state	= STALL;
				end
			end

			EBREAK_WAIT: begin
				if (ebreak_clear) begin
					nxt_state	= DEBUG;
				end else begin
					nxt_state	= EBREAK_WAIT;
				end
			end

			default: begin
				nxt_state	= DEBUG;
			end
		endcase
	end


	always_comb begin : switch_endian
		instr_switch =	(ENDIANESS == BIG_ENDIAN) ? instr_t'(instr_fifo_out.instr) : 
			instr_t'(swap_endian(data_t'(instr_fifo_out.instr)));
	end


	always_comb begin
		instr = instr_valid ? instr_switch : NOP;
		pc_out = instr_valid ? instr_fifo_out.pc : NULL;
	end


	mem_sys_axil_wrapper instr_fetcher (
		.clk			(clk),
		.rst_n			(rst_n),

		.addr			(pc),
		.data_in		(NULL),
		.wr				(DISABLE),
		.rd				(ifu_rden),
		.valid			(ifu_valid),
		.be				(4'b1111),
		
		.data_out		(instr_mem_sys),
		.done			(done),

		.axil_bus		(axil_bus)
	);


	fifo #(
		.BUF_WIDTH			(INSTR_QUE_ADDR_WIDTH),
		.DATA_WIDTH			(XLEN * 2)	// fits both instr and pc
	) instr_queue (
		.clk				(clk),
		.rst				((~rst_n) || flush),
		.buf_in				(instr_fifo_in),
		.buf_out			(instr_fifo_out),
		.wr_en				(done),
		.rd_en				(~stall), 
		.buf_empty			(buf_empty), 
		.buf_full			(buf_full), 
		.buf_almost_full	(buf_almost_full),
		.fifo_counter		(fifo_counter)
	);
	
endmodule : fetch_axil
