// Copyright (C) 2020 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

////////////////////////////////////////////////////////////////////////////////
////////////////////// STRATIX LCELL LUT for Formal Verification ///////////////
////////////////////////////////////////////////////////////////////////////////



module lcell_lut3 ( a, b, c, lutout );
	parameter lut_mask = 8'hff;

	input a, b, c;
	output lutout;

	wire active_a, active_b, active_c;

	reg lutval;

	////////// special purpose functions ////////////////////////////

	// ** function returns the lut output value ** // 

	function lut3;
        input [7:0] mask;
		input a, b, c;
		integer mask_index;
		reg [2:0] mask_reg_index;
		reg lut_value ;
        begin
			lut_value = 0;
			for( mask_index = 0; mask_index <= 7;
				 mask_index = mask_index + 1 )
			begin
				mask_reg_index = mask_index;
				lut_value = lut_value | ( (c ~^ mask_reg_index[2]) &
					(b ~^ mask_reg_index[1]) &
					(a ~^ mask_reg_index[0]) &
					(mask[mask_index]) );
			end
			lut3 = lut_value;
		end
	 endfunction

	// ** checks the LUT's dependency on data inputs **//

	function lutusesa;
        input [7:0] mask ;
        reg used;
        reg [3:0] bits1, bits2;
        begin
            bits1 = { mask[7], mask[5], mask[3], mask[1] };
            bits2 = { mask[6], mask[4], mask[2], mask[0] };
            used = | ( bits1 ^ bits2 );
            lutusesa = used;
        end
    endfunction

	function lutusesb;
        input [7:0] mask ;
        reg used;
        reg [3:0] bits1, bits2;
        begin
            bits1 = { mask[7:6], mask[3:2] };
            bits2 = { mask[5:4], mask[1:0] };
            used = | ( bits1 ^ bits2 );
            lutusesb = used;
        end
    endfunction

    function lutusesc ;
        input [7:0] mask;
		reg used;
        begin
			used = |(mask[7:4] ^ mask[3:0]);
			lutusesc = used;
        end
    endfunction

	generate
	case( lut_mask )
`ifdef LC_OPTIMIZED_FUNCTIONS
		8'h96 : begin
			assign lutout = a ^ b ^ c;
		end

		8'he8 : begin
			assign lutout = a & ( b | c ) | b & c;
		end

		8'h5a : begin
			assign lutout = a ^ c;
		end

		8'h69 : begin
			assign lutout = a ^ b ^ ~c;
		end

		8'h8e : begin
			assign lutout = a & ( b | ~c ) | b & ~c;
		end

		8'ha0 : begin
			assign lutout = a & c;
		end

		8'h17 : begin
			assign lutout = ~a & ( ~b | ~c ) | ~b & ~c;
		end

		8'hd4 : begin
			assign lutout = ~a & ( b | c ) | b & c;
		end

		8'ha5 : begin
			assign lutout = a ^ ~c;
		end

		8'h88 : begin
			assign lutout = a & b;
		end
`endif

		default : begin
			assign active_a = (lutusesa(lut_mask) == 1) ? a : 1'b0;
			assign active_b = (lutusesb(lut_mask) == 1) ? b : 1'b0;
			assign active_c = (lutusesc(lut_mask) == 1) ? c : 1'b0;

			assign lutout = lutval;

			always @( active_a or active_b or active_c )
				lutval = lut3( lut_mask, active_a, active_b,
					active_c );
		end
	endcase
	endgenerate
endmodule
