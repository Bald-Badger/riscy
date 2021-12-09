// Quartus Prime Verilog Template
// Single Port ROM
import defines::*;

module rom
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=12)
(
	input			[(ADDR_WIDTH-1):0] addr,
	input			clk, 
    input			rden,
	input			clken,
	output	logic	[(DATA_WIDTH-1):0] q
);

    reg [(DATA_WIDTH-1):0] q_raw;

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[0:2**ADDR_WIDTH-1];

	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file,
	// this design will not compile.

	// See Verilog LRM 1364-2001 Section 17.2.8 for details on the
	// format of this file, or see the "Using $readmemb and $readmemh"
	// template later in this section.
    integer fp, i;
	initial
	begin
        fp = $fopen("instr.bin","r");
        i = $fread(rom, fp);
	end

	logic gated_clk;

	always_comb begin
   		gated_clk = clk & clken;
	end

	data_t q_delay;

	assign q = rden ? q_delay : NULL;

	always_ff @( posedge clk ) begin
		if (clken)
			q_delay <= q_raw;
		else
			q_delay <= q_delay;
	end

	always_latch begin
		if(gated_clk) begin
			q_raw <= rom[addr];
		end
	end

endmodule : rom
