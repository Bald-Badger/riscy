`timescale 1ns / 1ps

// credit: https://github.com/Danishazmi29/Verilog-Code-of-Synchronus-FIFO-Design-with-verilog-test-code.git
// with modification

module fifo
	#(
		parameter	BUF_WIDTH	= 3,	// default: 2^3 = 8 entries
		parameter	DATA_WIDTH	= 32	// 32 bit fifo
	) (
	input	logic						clk, 
	input	logic						rst, 
	input	logic	[DATA_WIDTH-1:0]	buf_in, 
	input	logic						wr_en, 
	input	logic						rd_en,
	output	logic	[DATA_WIDTH-1:0]	buf_out, 
	output	logic						buf_empty, 
	output	logic						buf_full, 
	output	logic						buf_almost_full,
	output	logic	[BUF_WIDTH :0]		fifo_counter
);

localparam BUF_SIZE = (1<<BUF_WIDTH);


logic [BUF_WIDTH-1:0]		rd_ptr, wr_ptr;	// pointer to read and write addresses
logic [DATA_WIDTH-1:0]		buf_mem[0 : BUF_SIZE -1] /* synthesis ramstyle = "logic" */;


always_comb begin
	buf_empty = (fifo_counter == 0);	// Checking for whether buffer is empty or not
	buf_full = (fifo_counter == BUF_SIZE);	//Checking for whether buffer is full or not
	buf_almost_full = (fifo_counter == BUF_SIZE - 1) || buf_full;
end


//Setting FIFO counter value for different situations of read and write operations.
always_ff @(posedge clk) begin
	if( rst )
		fifo_counter <= 0;				// Reset the counter of FIFO
	else if( (!buf_full && wr_en) && ( !buf_empty && rd_en ) ) //When doing read and write operation simultaneously
		fifo_counter <= fifo_counter;	// At this state, counter value will remain same.
	else if( !buf_full && wr_en )		// When doing only write operation
		fifo_counter <= fifo_counter + 1;
	else if( !buf_empty && rd_en )		//When doing only read operation
		fifo_counter <= fifo_counter - 1;
	else
	  fifo_counter <= fifo_counter;		// When doing nothing.
end


// seriously, don't touch
// my other logic expects 1 cycle delay
// my other logic expects buf_out holds until next read
always_ff @( posedge clk or posedge rst) begin
	if( rst )
		buf_out <= 0;		//On reset output of buffer is all 0.
	else begin
		if( rd_en && !buf_empty )
			buf_out <= buf_mem[rd_ptr];	//Reading the data from buffer location indicated by read pointer
		else
			buf_out <= buf_out;
	end
end


always_ff @(posedge clk) begin
	if( wr_en && !buf_full )
		buf_mem[ wr_ptr ] <= buf_in;		//Writing data input to buffer location indicated by write pointer
	else
		buf_mem[ wr_ptr ] <= buf_mem[ wr_ptr ];
end


always_ff @(posedge clk) begin
	if( rst ) begin
	  wr_ptr <= 0;		// Initializing write pointer
	  rd_ptr <= 0;		//Initializing read pointer
	end else begin
		if( !buf_full && wr_en )	 
			wr_ptr <= wr_ptr + 1;		// On write operation, Write pointer points to next location
		else  
			wr_ptr <= wr_ptr;

		if( !buf_empty && rd_en )	
			rd_ptr <= rd_ptr + 1;		// On read operation, read pointer points to next location to be read
		else 
			rd_ptr <= rd_ptr;
	end
end

endmodule : fifo
