`timescale 1ps/1ps
import defines::*;
import mem_defines::*;

module sdram_my_tb;

//logic define
logic		clk;
logic		rst_n, but_rst_n;
logic		locked;
                                          
//logic define                             
logic		sdram_clk;
logic		sdram_cke;
logic		sdram_cs_n;
logic		sdram_ras_n;
logic		dram_cas_n;
logic		sdram_we_n;
logic[1:0]	sdram_ba;
logic[12:0]	sdram_addr;
wire [15:0]	sdram_data;
logic[1:0]	sdram_dqm;
                                          

initial begin
  clk = 0;
  but_rst_n     = 0;                      
  #100000
  but_rst_n     = 1;
end
assign rst_n = (but_rst_n & locked);

//??50Mhz??,????20ns
always #10000 clk = ~clk; 

pll_clk	pll_inst (
	.areset		(~but_rst_n),
	.inclk0		(clk),
	.locked		(locked),
	.c0			(clk_50m),
	.c1			(clk_100m),
	.c2			(clk_100m_shift)
);


data_t			addr_int;
sdram_addr_t	addr;
data_t			w0, w1, w2, w3;
sdram_8_wd_t	data;
sdram_8_wd_t	data_line_in, data_line_out;
logic wr, rd, valid, done, sdram_init_done;
data_t	mem_data_32b;
logic[15:0] mem_data_16b;
logic [15:0] mem [0:16777216];
integer err;

integer i;

initial begin
	for (i = 0; i < 16777216; i++) begin
		mem_data_32b = $urandom();
		mem_data_16b = mem_data_32b[15:0];
		mem[i] = mem_data_16b;
	end
end

function sdram_8_wd_t rand_8_wd();
	w0 = $urandom();
	w1 = $urandom();
	w2 = $urandom();
	w3 = $urandom();
	return sdram_8_wd_t'({w0, w1, w2, w3});
endfunction


function sdram_addr_t rand_addr();
	addr_int = $urandom() & 32'hffff_fffe;
	return sdram_addr_t'(addr_int[23:0]);
endfunction


task write_test(input sdram_addr_t address);
	@(posedge clk_50m);
	addr = address;
	data_line_in = {{mem[addr]},
					{mem[addr+1]},
					{mem[addr+2]},
					{mem[addr+3]},
					{mem[addr+4]},
					{mem[addr+5]},
					{mem[addr+6]},
					{mem[addr+7]}};
	wr = 1;
	valid = 1;
	@(posedge done);
	@(negedge clk_50m);
	wr = 0;
	valid = 0;
endtask

task read_test(input sdram_addr_t address);
	@(posedge clk_50m);
	addr = address;
	rd = 1;
	valid = 1;
	@(posedge done);
	@(negedge clk_50m);
	rd = 0;
	valid = 0;
	assert (data_line_out == {{mem[addr]},
					{mem[addr+1]},
					{mem[addr+2]},
					{mem[addr+3]},
					{mem[addr+4]},
					{mem[addr+5]},
					{mem[addr+6]},
					{mem[addr+7]}}
			) 
	else   $stop();
endtask


task init ();
	wr = 0;
	rd = 0;
	valid = 0;
	data_line_in = 0;
	err = 0;	
	@(posedge sdram_init_done);
	@(negedge clk_50m);
endtask


sdram_addr_t addr_gen;
integer num = 100000;
initial begin
	init();
	for (i = 0; i < num; i++) begin
		addr_gen = rand_addr();
		write_test(addr_gen);
		read_test(addr_gen);
	end

	repeat(100) @(negedge clk_50m);
	if (err) begin
		$display("test failed");
	end else begin
		$display("test passed");
	end
	$stop();
end


//??SDRAM??????
sdram sdram_ctrl_inst(
    .clk_50m		(clk_50m),
	.clk_100m		(clk_100m),
	.clk_100m_shift	(clk_100m_shift),
    .rst_n          (rst_n),              //??????????
        
    .sdram_clk      (sdram_clk),          //SDRAM ????
    .sdram_cke      (sdram_cke),          //SDRAM ????
    .sdram_cs_n     (sdram_cs_n),         //SDRAM ??
    .sdram_ras_n    (sdram_ras_n),        //SDRAM ???
    .sdram_cas_n    (sdram_cas_n),        //SDRAM ???
    .sdram_we_n     (sdram_we_n),         //SDRAM ???
    .sdram_ba       (sdram_ba),           //SDRAM Bank??
    .sdram_addr     (sdram_addr),         //SDRAM ?/???
    .sdram_data     (sdram_data),         //SDRAM ??
    .sdram_dqm      (sdram_dqm),          //SDRAM ????
    
	// user control interface
	// a transaction is complete when valid && done
	.addr			(addr),
	.wr				(wr),
	.rd				(rd),
	.valid			(valid),
	.data_line_in	(data_line_in),
	.data_line_out	(data_line_out),
	.done			(done),
	.sdram_init_done(sdram_init_done)
);  


//??SDRAM????    
sdr u_sdram(    
    .Clk            (sdram_clk),          //SDRAM ????
    .Cke            (sdram_cke),          //SDRAM ????
    .Cs_n           (sdram_cs_n),         //SDRAM ??
    .Ras_n          (sdram_ras_n),        //SDRAM ???
    .Cas_n          (sdram_cas_n),        //SDRAM ???
    .We_n           (sdram_we_n),         //SDRAM ???
    .Ba             (sdram_ba),           //SDRAM Bank??
    .Addr           (sdram_addr),         //SDRAM ?/???
    .Dq             (sdram_data),         //SDRAM ??
    .Dqm            (sdram_dqm)           //SDRAM ????
);
    
endmodule : sdram_my_tb
