import defines::*;
import mem_defines::*;

// synopsys translate_off
`timescale 1 ns / 1 ps
// synopsys translate_on


// TODO: add - save how to forward
// addi x1, x1, 4; sb x1, 0(x1)

module memory (
	input	logic				clk,
	input	logic				rst_n,
	input	data_t				addr,
	input	data_t				data_in_raw,
	input	data_t				mem_mem_fwd_data,
	input	mem_fwd_sel_t 		fwd_m2m, 		// mem to mem forwarding
	input	instr_t				instr,

	output	data_t				data_out,
	output	data_t				data_in_final,	// for debug
	output	logic				sdram_init_done,
	output	logic				done,

	axil_interface.axil_master	axil_bus
);

	// control signals
	opcode_t		opcode;
	funct3_t		funct3;
	funct5_t		funct5;
	logic 			wren, rden;
	logic			is_st, is_ld;
	logic			mem_access_done;
	logic			valid;

	// debug signals
	logic			addr_misalign;
	logic  			misalign_trap;

	// atomic contril signals
	instr_a_t		instr_a;
	logic			is_atomic, is_lr, is_sc;
	logic			update;		// enable exclusive monitor for a single cycle
	logic			sc_success;

	always_comb begin : signal_assign
		instr_a		=	instr_a_t'(instr);
		opcode		=	instr_a.opcode;
		funct3		=	instr_a.funct3;
		funct5		=	instr_a.funct5;
		is_atomic	=	opcode == ATOMIC;
		is_lr		=	is_atomic && funct5 == LR;
		is_sc		=	is_atomic && funct5 == SC;
		is_ld		=	opcode == LOAD;
		is_st		=	opcode == STORE;
		valid		=	wren || rden;
		sdram_init_done = DONE;
	end


	typedef enum logic[2:0] { 
		IDLE,		// no memory access
		REGULAR,	// actual memory access
		AMO1, AMO2	// other automic memory access
	} memory_ctrl_state_t;


	memory_ctrl_state_t state, nxt_state;
	always_ff @( posedge clk, negedge rst_n ) begin
		if (~rst_n)
			state <= IDLE;
		else 
			state <= nxt_state;
	end

	always_comb begin : memory_fsm_ctrl
		nxt_state	= IDLE;
		rden		= DISABLE;
		wren		= DISABLE;
		update		= DISABLE;
		done		= 1'b0;
		unique case (state)
			IDLE	: begin
				if (is_ld) begin
					nxt_state	= REGULAR;
					rden		= ENABLE;
					wren		= DISABLE;
					done		= 1'b0;
					update		= DISABLE;
				end else if (is_st) begin
					nxt_state	= REGULAR;
					rden		= DISABLE;
					wren		= ENABLE;
					done		= 1'b0;
					update		= DISABLE;
				end else if (is_lr) begin
					nxt_state	= REGULAR;
					rden		= ENABLE;
					wren		= DISABLE;
					done		= 1'b0;
					update		= DISABLE;
				end else if (is_sc) begin
					rden		= DISABLE;
					if (sc_success) begin // success, write 0 to rd
						nxt_state	= REGULAR;
						wren		= ENABLE;
						done		= 1'b0;
						update		= DISABLE;
					end else begin	// fail, write non-zero value to rd
						nxt_state	= IDLE;
						wren		= DISABLE;			
						done		= 1'b1;
						update		= ENABLE;
					end
				end else begin
					nxt_state	= IDLE;
					rden		= DISABLE;
					wren		= DISABLE;
					done		= 1'b0;
					update		= DISABLE;
				end
			end

			REGULAR	: begin
				if (mem_access_done) begin
					nxt_state	= IDLE;
					done		= 1'b1;
					wren		= is_st || is_sc;
					rden		= is_ld || is_lr;
					update		= is_sc || is_lr || is_st;
				end else begin
					nxt_state	= REGULAR;
					done		= 1'b0;
					wren		= is_st || is_sc;
					rden		= is_ld || is_lr;
					update		= DISABLE;
				end
			end

			default	: begin
				nxt_state	= IDLE;
				rden		= DISABLE;
				wren		= DISABLE;
				update		= DISABLE;
				done		= 1'b0;
			end

		endcase
	end


	logic[BYTES-1:0] be;
	always_comb begin : byte_enable_pharse
		if (wren) begin
			unique case (funct3)
				SB: begin
					unique case (addr[1:0])
						2'b00: be = 4'b1000;
						2'b01: be = 4'b0100;
						2'b10: be = 4'b0010;
						2'b11: be = 4'b0001;
					endcase
				end
				SH: begin
					unique case (addr[1])
						2'b0: be = 4'b1100;
						2'b1: be = 4'b0011;
					endcase
				end
				SW: begin
					be = 4'b1111;
				end
				default: be = 4'b0;
			endcase
		end else begin
			be = 4'b1111;
		end
	end

	// may need to switch endianess for storing in of memory depending on endianess
	data_t data_in;				// after fwd
	//data_t data_in_final; 	// decleared as output, after possible endian switch
	data_t data_out_mem; 		// data just out of mem, blue raw

	always_comb begin : sel_fwd_data
		data_in = (fwd_m2m == WB_MEM_SEL) ? mem_mem_fwd_data : data_in_raw;
	end

	// switch data endianess to little when storing if necessary
	always_comb begin : switch_endian_in
		if (wren) begin
			case (funct3)
				SB: begin
					case (addr[1:0])
						2'b00: data_in_final = {{data_in[7:0]},{8'b0},{8'b0},{8'b0}};
						2'b01: data_in_final = {{8'b0},{data_in[7:0]},{8'b0},{8'b0}};
						2'b10: data_in_final = {{8'b0},{8'b0},{data_in[7:0]},{8'b0}};
						2'b11: data_in_final = {{8'b0},{8'b0},{8'b0},{data_in[7:0]}};
					endcase
				end

				SH: begin
					case (addr[1])
						1'b0: begin
							if (ENDIANESS == BIG_ENDIAN)
								data_in_final = {{data_in[15:8]},{data_in[7:0]},{16'b0}};
							else 
								data_in_final = {{data_in[7:0]},{data_in[15:8]},{16'b0}};
						end
						1'b1: begin
							if (ENDIANESS == BIG_ENDIAN)
								data_in_final = {{16'b0},{data_in[15:8]},{data_in[7:0]}};
							else 
								data_in_final = {{16'b0},{data_in[7:0]},{data_in[15:8]}};
						end
					endcase
				end

				SW: begin
					if (ENDIANESS == BIG_ENDIAN)
						data_in_final = data_in;
					else 
						data_in_final = swap_endian(data_in);
				end

				default: begin
					data_in_final = NULL;
				end
			endcase
		end else begin
			data_in_final = NULL;
		end
	end

	word_t d;
	always_comb begin // abbr for shorter code
		d = word_t'(data_out_mem); 
	end

	mem_out_sel_t mem_out_sel;
	always_comb begin : mem_out_sel_assign
		mem_out_sel =	(is_ld || is_st) ? REGULAR_LD_OUT :
						(is_lr) ? LOAD_CONDITIONAL_OUT :
						(is_sc && sc_success) ? STORE_CONDITIONAL_SUC_OUT :
						(is_sc && ~sc_success) ? STORE_CONDITIONAL_FAIL_OUT:
						(is_atomic) ? AMO_INSTR_OUT:
						NULL_OUT;
	end

	always_comb begin : output_mask_pharse
		unique case (mem_out_sel)
			REGULAR_LD_OUT: begin
				unique case (funct3)
					LB:		begin
						case (addr[1:0])
							2'b00:	data_out = sign_extend_b(d.b0);
							2'b01:	data_out = sign_extend_b(d.b1);
							2'b10:	data_out = sign_extend_b(d.b2);
							2'b11:	data_out = sign_extend_b(d.b3);
						endcase
					end

					LH:		begin
						case (addr[1])
							1'b0: begin
								if (ENDIANESS == BIG_ENDIAN)
									data_out = sign_extend_h({{d.b0},{d.b1}});
								else 
									data_out = sign_extend_h({{d.b1},{d.b0}});
							end
							1'b1: begin
								if (ENDIANESS == BIG_ENDIAN)
									data_out = sign_extend_h({{d.b2},{d.b3}});
								else 
									data_out = sign_extend_h({{d.b3},{d.b2}});
							end
						endcase
					end

					LW:		begin
						if (ENDIANESS == BIG_ENDIAN)
							data_out = {{d.b0},{d.b1},{d.b2},{d.b3}};
						else
							data_out = {{d.b3},{d.b2},{d.b1},{d.b0}};
					end

					LBU:	begin
						case (addr[1:0])
							2'b00:	data_out = zero_extend_b(d.b0);
							2'b01:	data_out = zero_extend_b(d.b1);
							2'b10:	data_out = zero_extend_b(d.b2);
							2'b11:	data_out = zero_extend_b(d.b3);
						endcase
					end

					LHU:	begin
						case (addr[1])
							1'b0: begin
								if (ENDIANESS == BIG_ENDIAN)
									data_out = zero_extend_h({{d.b0},{d.b1}});
								else 
									data_out = zero_extend_h({{d.b1},{d.b0}});
							end
							1'b1: begin
								if (ENDIANESS == BIG_ENDIAN)
									data_out = zero_extend_h({{d.b2},{d.b3}});
								else 
									data_out = zero_extend_h({{d.b3},{d.b2}});
							end
						endcase
					end

					default:begin
						data_out = NULL;
					end
				endcase
			end

			LOAD_CONDITIONAL_OUT: begin
				if (ENDIANESS == BIG_ENDIAN)
					data_out = {{d.b0},{d.b1},{d.b2},{d.b3}};
				else
					data_out = {{d.b3},{d.b2},{d.b1},{d.b0}};
			end

			STORE_CONDITIONAL_SUC_OUT: begin
				data_out = SC_SUCCESS_CODE;
			end

			STORE_CONDITIONAL_FAIL_OUT: begin
				data_out = SC_FAIL_ECODE;
			end

			AMO_INSTR_OUT: begin
				data_out = NULL;
			end

			NULL_OUT: begin
				data_out = NULL;
			end

			default: begin
				data_out = NULL;
			end

		endcase
	end


	// exclusive monitor, used to see if a conditional store will success
	exclusive_monitor #(
		.RES_ENTRY_CNT	(MAX_NEST_LOCK)
	) exclusive_monitor_inst (
		.clk			(clk),
		.rst_n			(rst_n),
		.instr			(instr_a_t'(instr)),
		.addr			(addr),
		.mem_wr			(wren),
		.update			(update),
		.success		(sc_success)
	);

	mem_sys_axil memory_system (
		.clk			(clk),
		.rst_n			(rst_n),

		.addr			(addr),
		.data_in		(data_in_final),
		.wr				(wren),
		.rd				(rden),
		.valid			(valid),
		.be				(be),
		
		.data_out		(data_out_mem),
		.done			(mem_access_done),

		.m_axil_awaddr	(axil_bus.axil_awaddr),
		.m_axil_awprot	(axil_bus.axil_awprot),
		.m_axil_awvalid	(axil_bus.axil_awvalid),
		.m_axil_awready	(axil_bus.axil_awready),
		.m_axil_wdata	(axil_bus.axil_wdata),
		.m_axil_wstrb	(axil_bus.axil_wstrb),
		.m_axil_wvalid	(axil_bus.axil_wvalid),
		.m_axil_wready	(axil_bus.axil_wready),
		.m_axil_bresp	(axil_bus.axil_bresp),
		.m_axil_bvalid	(axil_bus.axil_bvalid),
		.m_axil_bready	(axil_bus.axil_bready),
		.m_axil_araddr	(axil_bus.axil_araddr),
		.m_axil_arprot	(axil_bus.axil_arprot),
		.m_axil_arvalid	(axil_bus.axil_arvalid),
		.m_axil_arready	(axil_bus.axil_arready),
		.m_axil_rdata	(axil_bus.axil_rdata),
		.m_axil_rresp	(axil_bus.axil_rresp),
		.m_axil_rvalid	(axil_bus.axil_rvalid),
		.m_axil_rready	(axil_bus.axil_rready)
	);


	////////////////////////// formal verification //////////////////////////

	//// misalign assersion ////
	always_comb begin
		unique case (funct3)
			LB:		addr_misalign = 1'b0;
			LH:		addr_misalign = addr[0];
			LW:		addr_misalign = |addr[1:0];
			LBU:	addr_misalign = 1'b0;
			LHU:	addr_misalign = addr[0];
			default:addr_misalign = 1'b0; 
		endcase
		misalign_trap = addr_misalign && (rden || wren) && valid;
	end

	property memory_address_misalign;
		disable iff (~rst_n)
		@(posedge clk) ~misalign_trap;
	endproperty
	
	assert property (memory_address_misalign)
		else $error("misaligned memory access");
	//////////////////////////


	//// write and rd in the same cycle ////
	property memory_conflicting_access;
		disable iff (~rst_n)
		@(posedge clk) ~(rden && wren);
	endproperty

	assert property (memory_conflicting_access)
		else $error("read and write mem at same access");
	///////////////////////////////////////

/*
	//// assume all access are below max physical memory ////
	logic			max_phy_access;
	logic			max_phy_access_trap;
	always_comb begin
		max_phy_access = $signed(addr) >= $signed(MAX_PHY_ADDR);
		max_phy_access_trap = max_phy_access && (rden || wren);
	end

	property memory_max_phy_access;
		disable iff (~rst_n)
		@(posedge clk) ~max_phy_access_trap;
	endproperty

	assert property (memory_max_phy_access)
		else $error("access exceed physical memory boundary");
	///////////////////////////////////////////////////////
*/
endmodule : memory
