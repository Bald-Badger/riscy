import defines::*;
import axi_defines::*;

module fetch_axil (
	// general input
	input	logic					clk, 
	input	logic					rst_n,

	// input
	input	data_t					pc_bj,
	input 	logic					pc_sel,
	input 	logic					stall,
	input	logic					flush,
	input	logic					go,
	input	instr_t					instr_w,

	// output
	output	data_t					pc_p4_out,
	output	data_t					pc_out,
	output	instr_t					instr,
	output	logic					taken,
	output	logic					instr_valid,

	// AXI Lite bus interface
	axi_lite_interface				axil_bus
);

	localparam INSTR_QUE_ADDR_WIDTH = 4;

	typedef struct packed {
		instr_t	instr;
		data_t	pc;
	}instr_queue_entry_t;

	logic [INSTR_QUE_ADDR_WIDTH:0] fifo_counter;
	logic ecall, ecall_clear;
	logic instr_mem_rden;
	logic instr_mem_rdvalid;
	logic done;
	logic clear_flush_flag, flush_flag; // should be a flag
	
	logic buf_empty, buf_full, buf_almost_full;

	logic ifu_rden, ifu_valid;

	// pc control logic
	logic[XLEN-1:0] boot_pc [0:0];
	data_t pc, pc_p4;

	assign pc_p4 = pc + 32'd4;

	// TODO: assert flush && pc_sel
	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			pc <= NULL;
		end else if (flush) begin
			pc <= pc_bj;
		end else if (buf_almost_full) begin
			pc <= pc;
		end else begin
			pc <= pc_p4;
		end
	end
	// end pc control logic

	// instruction wires
	instr_queue_entry_t instr_fifo_in, instr_fifo_out;
	instr_t instr_mem_sys;
	assign instr_fifo_in = instr_queue_entry_t'({instr_mem_sys, pc});
	assign ecall = instr_mem_sys == ECALL;
	assign ecall_clear = instr_w == ECALL;
	assign instr_valid = (!buf_empty) && (~stall);
	// end instruction wires

	// state explained in latter FSM logic
	typedef enum logic[2:0] {
		DEBUG,
		FETCH,
		WAIT,
		STALL,
		ECALL
	} state_t;

	state_t state, nxt_state;

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			state <= DEBUG;
		else
			state <= nxt_state;
	end

	logic instr_good;

	always_comb begin
		nxt_state			= DEBUG;
		ifu_rden			= DISABLE;
		ifu_valid			= INVALID;
		unique case (state)

			// init state, the CPU stall due to a ecall instruction
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
				end else if (done && ecall) begin
					nxt_state	= ECALL;
				end else begin
					nxt_state	= FETCH;
				end
			end
/*
			WAIT: begin
				ifu_rden = ENABLE;
				ifu_valid = VALID;
				if (~done) begin
					nxt_state	= WAIT;
				end else if (done && ecall) begin
					nxt_state	= ECALL;
				end else if (done && buf_almost_full) begin
					nxt_state	= STALL;
				end else begin	// done, normal instr, and buf not full
					nxt_state	= FETCH;
				end
			end
*/
			// instruction issue almoat full, stall fetch
			STALL: begin
				if (~buf_almost_full) begin
					nxt_state	= FETCH;
				end else begin
					nxt_state	= STALL;
				end
			end

			ECALL: begin
				if (ecall_clear) begin
					nxt_state	= DEBUG;
				end else begin
					nxt_state	= ECALL;
				end
			end

			default: begin
				nxt_state	= DEBUG;
			end
		endcase
	end


	always_comb begin : switch_endian
		if (BOOT_TYPE == BINARY_BOOT) begin
			instr =	(ENDIANESS == BIG_ENDIAN) ? instr_t'(instr_fifo_out.instr) : 
					instr_t'(swap_endian(data_t'(instr_fifo_out.instr)));
		end else if (BOOT_TYPE == RARS_BOOT) begin
			instr = instr_t'(instr_fifo_out.instr);
		end else begin
			instr = NULL;
		end
	end

	always_comb begin
		pc_out = instr_fifo_out.pc;
		pc_p4_out = pc_out + 32'd4;
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


	// not implemented yet
	branch_predict branch_predictor (
		.instr	(instr),
		.taken	(taken)
	);
	
endmodule : fetch_axil
