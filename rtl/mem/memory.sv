`include "../opcode.svh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module memory (
	input logic 	clk,
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

	always_comb begin
		opcode = instr.opcode;
		funct3 = instr.funct3;
		rden = (opcode == LOAD);
		wren = (opcode == STORE);
	end


	logic[BYTES-1:0] be;
	always_comb begin : byte_enable_pharse
		be = 4'b0;
		if (wren) begin
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
	data_t data_in;		// after fwd
	data_t data_in_final; // after possible endian switch
	data_t data_out_mem; // data just out of mem, blue raw
	data_t data_out_unmasked; // data unmasked yet

	always_comb begin : sel_fwd_data
		assign data_in = (fwd_m2m == MEM_MEM_FWD_SEL) ? mem_mem_fwd_data : data_in_raw;
	end

	// switch data endianess to little when storing if necessary
	always_comb begin : switch_endian_in
		data_in_final = (ENDIANESS == BIG_ENDIAN) ? data_in : swap_endian(data_in);
	end

	// switch data endianess to big when loading if necessary
	always_comb begin : switch_endian_out
		data_out_unmasked = (ENDIANESS == BIG_ENDIAN) ? data_out_mem : swap_endian(data_out_mem);
	end

	data_t d = data_out_unmasked; // abbr for shorter code
	always_comb begin : output_mask_pharse
		data_out = NULL;

		if (wren) begin
			unique case (funct3)
				LB: 	 data_out = {d[7]*24, d[7:0]};
				LH: 	 data_out = {d[15]*24, d[15:0]};
				LW: 	 data_out = d;
				LBU: 	 data_out = {24'b0, d[7:0]};
				LHU: 	 data_out = {16'b0, d[15:0]};
				default: data_out = NULL;
			endcase
		end else begin
			data_out = NULL;
		end
	end

	mem #(
		.ADDR_WIDTH	(XLEN),
		.BYTES		(BYTES),
		.TYPE		(BLANK_MEM)
	) data_mem_inst (
		.waddr		(addr),
		.raddr		(addr),
		.be			(be),
		.wdata		(data_in_final),
		.we			(wren),
		.re			(rden),
		.clk		(clk),
		.q			(data_out_mem)
	);

endmodule : memory
