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



module lcell_lut4 ( a, b, c, d, lutout );
	parameter lut_mask = 16'hffff;

	input a, b, c, d;
	output lutout;

	wire active_a, active_b, active_c, active_d;

	reg lutval;

	////////// special purpose functions ////////////////////////////

	// ** function returns the lut output value ** // 

	function lut4;
        input [15:0] mask;
		input a, b, c, d ;
		integer mask_index;
		reg [3:0] mask_reg_index;
		reg lut_value ;
        begin
			lut_value = 0;
			for( mask_index = 0; mask_index <= 15;
				 mask_index = mask_index + 1 )
			begin
				mask_reg_index = mask_index;
				lut_value = lut_value | ( (d ~^ mask_reg_index[3]) &
					(c ~^ mask_reg_index[2]) &
					(b ~^ mask_reg_index[1]) &
					(a ~^ mask_reg_index[0]) &
					(mask[mask_index]) );
			end
			lut4 = lut_value;
		end
	 endfunction

	// ** checks the LUT's dependency on data inputs **//

    function lutusesa;
        input [15:0] mask ;
        reg used;
		reg [7:0] bits1, bits2;
        begin
			bits1 = { mask[15], mask[13], mask[11], mask[9],
				mask[7], mask[5], mask[3], mask[1] };
			bits2 = { mask[14], mask[12], mask[10], mask[8],
				mask[6], mask[4], mask[2], mask[0] };
			used = | ( bits1 ^ bits2 );
            lutusesa = used;
        end
    endfunction

    function lutusesb;
        input [15:0] mask ;
        reg used;
		reg [7:0] bits1, bits2;
        begin
			bits1 = { mask[15:14], mask[11:10], mask[7:6], mask[3:2] };
			bits2 = { mask[13:12], mask[9:8], mask[5:4], mask[1:0] };
			used = | ( bits1 ^ bits2 );
            lutusesb = used;
        end
    endfunction

    function lutusesc;
        input [15:0] mask ;
        reg used;
		reg [7:0] bits1, bits2;
        begin
			bits1 = { mask[15:12], mask[7:4] };
			bits2 = { mask[11:8], mask[3:0] };
			used = | ( bits1 ^ bits2 );
            lutusesc = used;
        end
    endfunction

    function lutusesd ;
        input [15:0] mask ;
        reg used;
        begin
			used = | ( mask[15:8] ^ mask[7:0] );
            lutusesd = used;
        end
    endfunction

    generate
    case( lut_mask )
`ifdef LC_OPTIMIZED_FUNCTIONS
        16'h6996 : begin
            assign lutout = a ^ b ^ c ^ d;
        end

        16'hfffe : begin
            assign lutout = a | b | c | d;
        end

        16'hf588 : begin
            assign lutout = d & ( c | ~a ) | ~d & a & b;
        end

        16'hb9a8 : begin
            assign lutout = a & ( b | c ) | ~a & ~b & d;
        end

        16'hd9c8 : begin
            assign lutout = b & ( a | c ) | ~b & ~a & d;
        end

        16'hf388 : begin
            assign lutout = d & ( c | ~b ) | ~d & a & b;
        end

        16'h9669 : begin
            assign lutout = a ^ b ^ c ^ ~d;
        end

        16'he6a2 : begin
            assign lutout = a & ( c | ~b ) | ~a & b & d;
        end

        16'he6c4 : begin
            assign lutout = b & ( c | ~a ) | ~b & a & d;
        end

        16'heac0 : begin
            assign lutout = a & d | b & c;
        end

        16'hff00 : begin
            assign lutout = d;
        end

        16'h00ff : begin
            assign lutout = ~d;
        end

        16'h0f0f : begin
            assign lutout = ~c;
        end

        16'h3333 : begin
            assign lutout = ~b;
        end

        16'h5555 : begin
            assign lutout = ~a;
        end

        16'hf0f0 : begin
            assign lutout = c;
        end

        16'hdda0 : begin
            assign lutout = d & ( b | ~a ) | ~d & a & c;
        end

        16'hd9c8 : begin
            assign lutout = b & ( a | c ) | ~b & ~a & d;
        end

        16'hacac : begin
            assign lutout = c & a | ~c & b;
        end

        16'hd8d8 : begin
            assign lutout = a & b | ~a & c;
        end

        16'h8000 : begin
            assign lutout = a & b & c & d;
        end

        16'h8888 : begin
            assign lutout = a & b;
        end

        16'haaaa : begin
            assign lutout = a;
        end

        16'hf000 : begin
            assign lutout = c & d;
        end
`endif

        default : begin
			assign active_a = (lutusesa(lut_mask) == 1) ? a : 1'b0;
			assign active_b = (lutusesb(lut_mask) == 1) ? b : 1'b0;
			assign active_c = (lutusesc(lut_mask) == 1) ? c : 1'b0;
			assign active_d = (lutusesd(lut_mask) == 1) ? d : 1'b0;

            assign lutout = lutval;

			always @( active_a or active_b or active_c or active_d ) begin
				lutval = lut4( lut_mask, active_a, active_b,
					 active_c, active_d );
			end
        end
    endcase
    endgenerate
endmodule
