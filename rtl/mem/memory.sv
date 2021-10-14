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

	output data_t	data_out
);

	opcode_t		opcode;
	funct3_t		funct3;
	logic 			wren, rden;
	logic			addr_misalign;
	logic  			misalign_trap;

	always_comb begin
		opcode = instr.opcode;
		funct3 = instr.funct3;
		rden = (opcode == LOAD);
		wren = (opcode == STORE);
	end

	assign misalign_trap = addr_misalign && (rden || wren);
	always_comb begin : misalign_detection
		unique case (funct3)
			LB:		addr_misalign = 1'b0;
			LH:		addr_misalign = addr[0];
			LW:		addr_misalign = &addr[1:0];
			LBU:	addr_misalign = 1'b0;
			LHU:	addr_misalign = addr[0];
			default:addr_misalign = 1'b0; 
		endcase
	end
	
	// synthesis translate_off   
	always @(posedge misalign_trap) begin
		$display("address misalign detected");
		$timeformat(-12, 0, "ps");
	end
	// synthesis translate_on 


	logic[BYTES-1:0] be;
	always_comb begin : byte_enable_pharse
		be = 4'b0;
		if (wren || rden) begin
			unique case (funct3)
				SB: be = (BIG_ENDIAN) ? B_EN_BIG : B_EN_LITTLE;
				SH: be = (BIG_ENDIAN) ? H_EN_BIG : H_EN_LITTLE;
				SW: be = (BIG_ENDIAN) ? W_EN_BIG : W_EN_LITTLE;
				default: be = 4'b0;
			endcase
		end else begin
			be = 4'b0;
		end
	end

	// may need to switch endianess for storing in of memory depending on endianess
	data_t data_in;				// after fwd
	data_t data_in_final; 		// after possible endian switch
	data_t data_out_mem; 		// data just out of mem, blue raw
	data_t data_out_unmasked;	// data unmasked yet

	always_comb begin : sel_fwd_data
		data_in = (fwd_m2m == MEM_MEM_FWD_SEL) ? mem_mem_fwd_data : data_in_raw;
	end

	// switch data endianess to little when storing if necessary
	always_comb begin : switch_endian_in
		data_in_final = (ENDIANESS == BIG_ENDIAN) ? data_in : swap_endian(data_in);
	end

	// switch data endianess to big when loading if necessary
	always_comb begin : switch_endian_out
		data_out_unmasked = (ENDIANESS == BIG_ENDIAN) ? data_out_mem : swap_endian(data_out_mem);
	end

	data_t d;
	assign d = data_out_unmasked; // abbr for shorter code
	
	always_comb begin : output_mask_pharse
		data_out = NULL;

		if (wren) begin
			unique case (funct3)
				LB: 	 data_out = {{24{d[7]}}, d[7:0]};
				LH: 	 data_out = {{16{d[15]}}, d[15:0]};
				LW: 	 data_out = d;
				LBU: 	 data_out = {24'b0, d[7:0]};
				LHU: 	 data_out = {16'b0, d[15:0]};
				default: data_out = NULL;
			endcase
		end else begin
			data_out = NULL;
		end
	end


	ram_32b_1024wd	data_mem_inst (
	.address ( addr[11:2] ),
	//.byteena ( be ),
	.clock ( clk ),
	.data ( data_in_final ),	
	.rden ( rden ),
	.wren ( wren ),
	.q ( data_out_mem )
	);


endmodule : memory
