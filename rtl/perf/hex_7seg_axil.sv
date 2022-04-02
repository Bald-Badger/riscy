module hex_7seg_axil #(
	// Width of data bus in bits
	parameter DATA_WIDTH = 32,
	// Width of address bus in bits
	parameter ADDR_WIDTH = 16,
	// Width of wstrb (width of data bus in words)
	parameter STRB_WIDTH = (DATA_WIDTH/8),
	// Extra pipeline register on output
	parameter PIPELINE_OUTPUT = 0
)(
	input  wire						clk,
	input  wire						rst,

	input  wire [ADDR_WIDTH-1:0]	s_axil_awaddr,
	input  wire [2:0]				s_axil_awprot,
	input  wire						s_axil_awvalid,
	output wire						s_axil_awready,
	input  wire [DATA_WIDTH-1:0]	s_axil_wdata,
	input  wire [STRB_WIDTH-1:0]	s_axil_wstrb,
	input  wire						s_axil_wvalid,
	output wire						s_axil_wready,
	output wire [1:0]				s_axil_bresp,
	output wire						s_axil_bvalid,
	input  wire						s_axil_bready,
	input  wire [ADDR_WIDTH-1:0]	s_axil_araddr,
	input  wire [2:0]				s_axil_arprot,
	input  wire						s_axil_arvalid,
	output wire						s_axil_arready,
	output wire [DATA_WIDTH-1:0]	s_axil_rdata,
	output wire [1:0]				s_axil_rresp,
	output wire						s_axil_rvalid,
	input  wire						s_axil_rready,

	output wire [6:0]				HEX0,
	output wire [6:0]				HEX1,
	output wire [6:0]				HEX2,
	output wire [6:0]				HEX3,
	output wire [6:0]				HEX4,
	output wire [6:0]				HEX5
);

	localparam	VALID_ADDR_WIDTH = ADDR_WIDTH - $clog2(STRB_WIDTH);
	localparam	WORD_WIDTH = STRB_WIDTH;
	localparam	WORD_SIZE = DATA_WIDTH/WORD_WIDTH;

	reg mem_wr_en;
	reg mem_rd_en;

	reg s_axil_awready_reg = 1'b0, s_axil_awready_next;
	reg s_axil_wready_reg = 1'b0, s_axil_wready_next;
	reg s_axil_bvalid_reg = 1'b0, s_axil_bvalid_next;
	reg s_axil_arready_reg = 1'b0, s_axil_arready_next;
	reg [DATA_WIDTH-1:0] s_axil_rdata_reg = {DATA_WIDTH{1'b0}}, s_axil_rdata_next;
	reg s_axil_rvalid_reg = 1'b0, s_axil_rvalid_next;
	reg [DATA_WIDTH-1:0] s_axil_rdata_pipe_reg = {DATA_WIDTH{1'b0}};
	reg s_axil_rvalid_pipe_reg = 1'b0;

	// (* RAM_STYLE="BLOCK" *)
	reg [DATA_WIDTH-1:0] mem[0:(2**VALID_ADDR_WIDTH)-1];

	wire [VALID_ADDR_WIDTH-1:0] s_axil_awaddr_valid = s_axil_awaddr >> (ADDR_WIDTH - VALID_ADDR_WIDTH);
	wire [VALID_ADDR_WIDTH-1:0] s_axil_araddr_valid = s_axil_araddr >> (ADDR_WIDTH - VALID_ADDR_WIDTH);

	assign s_axil_awready = s_axil_awready_reg;
	assign s_axil_wready = s_axil_wready_reg;
	assign s_axil_bresp = 2'b00;
	assign s_axil_bvalid = s_axil_bvalid_reg;
	assign s_axil_arready = s_axil_arready_reg;
	assign s_axil_rdata = PIPELINE_OUTPUT ? s_axil_rdata_pipe_reg : s_axil_rdata_reg;
	assign s_axil_rresp = 2'b00;
	assign s_axil_rvalid = PIPELINE_OUTPUT ? s_axil_rvalid_pipe_reg : s_axil_rvalid_reg;

	integer i, j;

	integer fp, s;

	// synthesis translate_off
	initial begin
		// two nested loops for smaller number of iterations per loop
		// workaround for synthesizer complaints about large loop counts
		for (i = 0; i < 2**VALID_ADDR_WIDTH; i = i + 2**(VALID_ADDR_WIDTH/2)) begin
			for (j = i; j < i + 2**(VALID_ADDR_WIDTH/2); j = j + 1) begin
				mem[j] = 0;
			end
		end

		case (BOOT_TYPE)
			BINARY_BOOT: begin
				fp = $fopen("instr.bin","r");
				if (fp == 0) begin
					$error("failed to open boot file\n");
					$finish();
				end
				s = $fread(mem, fp);
				$fclose(fp);
			end
			
			RARS_BOOT: begin
				$readmemh("instr.mc", mem);
			end

			default: begin
				$display("unkown boot type!");
			end
		endcase
	end
	// synthesis translate_on

	always @* begin
		mem_wr_en = 1'b0;

		s_axil_awready_next = 1'b0;
		s_axil_wready_next = 1'b0;
		s_axil_bvalid_next = s_axil_bvalid_reg && !s_axil_bready;

		if (s_axil_awvalid && s_axil_wvalid && (!s_axil_bvalid || s_axil_bready) && (!s_axil_awready && !s_axil_wready)) begin
			s_axil_awready_next = 1'b1;
			s_axil_wready_next = 1'b1;
			s_axil_bvalid_next = 1'b1;

			mem_wr_en = 1'b1;
		end
	end

	always @(posedge clk) begin
		s_axil_awready_reg <= s_axil_awready_next;
		s_axil_wready_reg <= s_axil_wready_next;
		s_axil_bvalid_reg <= s_axil_bvalid_next;

		for (i = 0; i < WORD_WIDTH; i = i + 1) begin
			if (mem_wr_en && s_axil_wstrb[i]) begin
				mem[s_axil_awaddr_valid][WORD_SIZE*i +: WORD_SIZE] <= s_axil_wdata[WORD_SIZE*i +: WORD_SIZE];
			end
		end

		if (rst) begin
			s_axil_awready_reg <= 1'b0;
			s_axil_wready_reg <= 1'b0;
			s_axil_bvalid_reg <= 1'b0;
		end
	end

	always @* begin
		mem_rd_en = 1'b0;

		s_axil_arready_next = 1'b0;
		s_axil_rvalid_next = s_axil_rvalid_reg && !(s_axil_rready || (PIPELINE_OUTPUT && !s_axil_rvalid_pipe_reg));

		if (s_axil_arvalid && (!s_axil_rvalid || s_axil_rready || (PIPELINE_OUTPUT && !s_axil_rvalid_pipe_reg)) && (!s_axil_arready)) begin
			s_axil_arready_next = 1'b1;
			s_axil_rvalid_next = 1'b1;

			mem_rd_en = 1'b1;
		end
	end

	always @(posedge clk) begin
		s_axil_arready_reg <= s_axil_arready_next;
		s_axil_rvalid_reg <= s_axil_rvalid_next;

		if (mem_rd_en) begin
			s_axil_rdata_reg <= mem[s_axil_araddr_valid];
		end

		if (!s_axil_rvalid_pipe_reg || s_axil_rready) begin
			s_axil_rdata_pipe_reg <= s_axil_rdata_reg;
			s_axil_rvalid_pipe_reg <= s_axil_rvalid_reg;
		end

		if (rst) begin
			s_axil_arready_reg <= 1'b0;
			s_axil_rvalid_reg <= 1'b0;
			s_axil_rvalid_pipe_reg <= 1'b0;
		end
	end

	logic [3:0] a0, a1, a2, a3, a4, a5;

	// reg [DATA_WIDTH-1:0] mem[0:(2**VALID_ADDR_WIDTH)-1];
	always_ff @(posedge clk) begin
		a0 <= mem[0][7:4];
		a1 <= mem[0][3:0];
		a2 <= 0;
		a3 <= 0;
		a4 <= mem[0][31:28];
		a5 <= mem[0][27:24];
	end

	hex7seg h0 (
		.a	(a0),
		.y	(HEX0)
	);

	hex7seg h1 (
		.a	(a1),
		.y	(HEX1)
	);

	hex7seg h2 (
		.a	(a2),
		.y	(HEX2)
	);

	hex7seg h3 (
		.a	(a3),
		.y	(HEX3)
	);

	hex7seg h4 (
		.a	(a4),
		.y	(HEX4)
	);

	hex7seg h5 (
		.a	(a5),
		.y	(HEX5)
	);

endmodule : hex_7seg_axil
