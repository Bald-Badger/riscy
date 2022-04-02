module hex7seg (
	input logic  [3:0] a,
	output logic [6:0] y
);

	logic [6:0] yh;	// active high version of y
	always_comb begin
		unique case (a)
			4'h0:		yh = 7'b0111111;
			4'h1:		yh = 7'b0000110;
			4'h2:		yh = 7'b1011011;
			4'h3:		yh = 7'b1001111;
			4'h4:		yh = 7'b1100110;
			4'h5:		yh = 7'b1101101;
			4'h6:		yh = 7'b1111101;
			4'h7:		yh = 7'b0000111;
			4'h8:		yh = 7'b1111111;
			4'h9:		yh = 7'b1101111;
			4'ha:		yh = 7'b1110111;
			4'hb:		yh = 7'b1111100;
			4'hc:		yh = 7'b0111001;
			4'hd:		yh = 7'b1011110;
			4'he:		yh = 7'b1111001;
			4'hf:		yh = 7'b1110001;
			default:	yh = 7'b0000000;
		endcase
		y = ~yh;
	end

endmodule : hex7seg
