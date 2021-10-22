import defines::*;
import mem_defines::*;

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on


// TODO: add - save 这种情况如何forward
// addi x1, x1, 4; sb x1, 0(x1)

module memory (
	input logic 	clk,
	input logic		clk_100m,
	input logic		clk_100m_shift,
	input logic		rst_n,
	input data_t	addr,
	input data_t	data_in_raw,
	input data_t	mem_mem_fwd_data,
	input fwd_sel_t fwd_m2m, // mem to mem forwarding
	input instr_t	instr,

	output data_t	data_out,
	output logic	sdram_init_done,
	output logic	mem_access_done
);

	opcode_t		opcode;
	funct3_t		funct3;
	logic 			wren, rden;
	logic			addr_misalign;
	logic  			misalign_trap;


	always_comb begin
		opcode	= instr.opcode;
		funct3	= instr.funct3;
		rden	= (opcode == LOAD);
		wren	= (opcode == STORE);
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
	data_t data_in_final; 		// after possible endian switch
	data_t data_out_mem; 		// data just out of mem, blue raw

	always_comb begin : sel_fwd_data
		data_in = (fwd_m2m == MEM_MEM_FWD_SEL) ? mem_mem_fwd_data : data_in_raw;
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
		assign d = word_t'(data_out_mem); 
	end
	
	// bug!
	always_comb begin : output_mask_pharse
		if (rden) begin
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
						data_out = {{d.b3},{d.b3},{d.b1},{d.b0}};
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
		end else begin
			data_out = NULL;
		end
	end

	
	mem_sys memory_system (
		.clk_50m		(clk),
		.clk_100m		(clk_100m),
		.clk_100m_shift	(clk_100m_shift),
		.rst_n			(rst_n),

		.addr			(addr),
		.data_in		(data_in_final),
		.wr				(wren),
		.rd				(rden),
		.valid			(wren || rden),
		.be				(be),
		
		.data_out		(data_out_mem),
		.done			(mem_access_done),
		.sdram_init_done(sdram_init_done)
	);

	// synthesis translate_off 
	assign misalign_trap = addr_misalign && (rden || wren);
	always_comb begin : misalign_detection
		unique case (funct3)
			LB:		addr_misalign = 1'b0;
			LH:		addr_misalign = addr[0];
			LW:		addr_misalign = |addr[1:0];
			LBU:	addr_misalign = 1'b0;
			LHU:	addr_misalign = addr[0];
			default:addr_misalign = 1'b0; 
		endcase
	end
	
	always @(negedge clk) begin
		if (misalign_trap) begin
			$strobe("address misalign detected, funct3 is %b, addr is: %h", funct3, addr);
		end
	end
	// synthesis translate_on 


endmodule : memory
