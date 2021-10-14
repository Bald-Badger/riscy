import defines::*;
import mem_defines::*;

/*
	top module of sdram controll module,
	uses valid-ready handshake method,
	each read/write only load/read 8 16-bit word !!!
	if want to store more than 8 word, 
	change sdram_cmd.v parameter into whole page burst mode
	and change wr_len
	if want to store less than 8 word, change wr_len only
	and it sould be just fine
*/
module sdram(
    input					clk,			//FPGA外部时钟，50M
    input					rst_n,			//按键复位，低电平有效
    //SDRAM 芯片接口
    output					sdram_clk,		//SDRAM 芯片时钟
    output					sdram_cke,		//SDRAM 时钟有效
    output					sdram_cs_n,		//SDRAM 片选
    output       	 		sdram_ras_n,	//SDRAM 行有效
    output     	   			sdram_cas_n,	//SDRAM 列有效
    output        			sdram_we_n,		//SDRAM 写有效
    output	[ 1:0]			sdram_ba,		//SDRAM Bank地址
    output	[12:0]			sdram_addr,		//SDRAM 行/列地址
    inout	[15:0]			sdram_data,		//SDRAM 数据
    output	[ 1:0]			sdram_dqm,		//SDRAM 数据掩码

	// user control interface
	// a transaction is complete when valid && done
	input	logic	[23:0]	addr,
	input	logic			wr,
	input	logic			rd,
	input	logic			valid,
	input	sdram_8_wd_t	data_line_in,
	output	sdram_8_wd_t	data_line_out,
	output	logic			done,
	output	logic			sdram_init_done
);
    
//logic define
logic		clk_50m;                        //SDRAM 读写测试时钟
logic		clk_100m;                       //SDRAM 控制器时钟
logic		clk_100m_shift;                 //相位偏移时钟
     
logic		wr_en;                          //SDRAM 写端口:写使能
logic[15:0]	wr_data;                        //SDRAM 写端口:写入的数据
logic		rd_en;                          //SDRAM 读端口:读使能
logic[15:0]	rd_data;                        //SDRAM 读端口:读出的数据

logic		locked;                         //PLL输出有效标志
logic		sys_rst_n;                      //系统复位信号

logic		idle;
rd_index_t	rd_index;						//index of where rd_data is placed in data_line_out
logic		sdram_read;						// read sdram, not read fifo
											// rd_en reads fifo
logic		about_to_refresh;				// yield all operation, wait to finish
logic 		busy;							// FSM not in idle state
logic		load;
logic		write_done_flag; // half cycle
logic		read_done_flag;
logic		write_done_0, write_done_1, write_done_2;
logic		read_done_0, read_done_1, read_done_2;
logic		write_done;	// full cycle
logic		read_done;

always_comb begin : r_w_flag_assign
	write_done_flag = u_sdram_top.u_sdram_fifo_ctrl.write_done_flag;
	read_done_flag = u_sdram_top.u_sdram_fifo_ctrl.read_done_flag;
	write_done = write_done_0 || write_done_1 || write_done_2;
	read_done = read_done_0 || read_done_1 || read_done_2;
end

always_ff @(posedge clk_100m_shift or negedge rst_n)
	if (!rst_n) begin
		write_done_0 <= 1'b0;
		write_done_1 <= 1'b0;
		write_done_2 <= 1'b0;
		read_done_0 <= 1'b0;
		read_done_1 <= 1'b0;
		read_done_2 <= 1'b0;
	end else begin
		write_done_0 <= write_done_flag;
		write_done_1 <= write_done_0;
		write_done_2 <= write_done_1;
		read_done_0 <= read_done_flag;
		read_done_1 <= read_done_0;
		read_done_2 <= read_done_1;
	end

typedef enum logic[4:0] {
	IDLE,
	RFS,	// SDRAM refresh, cant do anything during refresh
	WR_LOAD,
	WR0, WR1, WR2, WR3, WR4, WR5, WR6, WR7,
	WR_WAIT,
	RD_LOAD,
	RD0, RD1, RD2, RD3, RD4, RD5, RD6, RD7,
	RD_WAIT,
	DONE
} state_t;

state_t state, nxt_state;

//待PLL输出稳定之后，停止系统复位
assign sys_rst_n = rst_n & locked;
assign about_to_refresh = u_sdram_top.u_sdram_controller.u_sdram_ctrl.cnt_refresh >= 11'd775;
assign idle = u_sdram_top.u_sdram_controller.u_sdram_ctrl.work_state == 0;
assign busy = (state != IDLE) && sdram_init_done;

always_ff @(posedge clk_50m or negedge sys_rst_n)
	if (!sys_rst_n)
		state <= IDLE;
	else
		state <= nxt_state;

always_comb begin : SDRAM_user_input_fsm
	nxt_state = IDLE;
	wr_en = 1'b0;
	wr_data = 16'b0;
	rd_en = 1'b0;
	load = 1'b0;
	rd_index = RD_DISABLE;
	sdram_read = 1'b0;
	done = 1'b0;
	case (state)
		IDLE: begin
			// refresh instr gives out when counter reach 11'd780;
			if (!sdram_init_done) begin
				nxt_state = IDLE;
			end else if (about_to_refresh) begin
				nxt_state = RFS;
			end else if (valid && wr) begin
				nxt_state = WR_LOAD;
			end else if (valid && rd) begin
				nxt_state = RD_LOAD;
			end else begin
				nxt_state = IDLE;
			end
		end

		WR_LOAD: begin
			nxt_state = WR0;
			load = 1'b1;
		end

		WR0: begin
			nxt_state = WR1;
			wr_en = 1'b1;
			wr_data = data_line_in.w0;
		end

		WR1: begin
			nxt_state = WR2;
			wr_en = 1'b1;
			wr_data = data_line_in.w1;
		end

		WR2: begin
			nxt_state = WR3;
			wr_en = 1'b1;
			wr_data = data_line_in.w2;
		end

		WR3: begin
			nxt_state = WR4;
			wr_en = 1'b1;
			wr_data = data_line_in.w3;
		end

		WR4: begin
			nxt_state = WR5;
			wr_en = 1'b1;
			wr_data = data_line_in.w4;
		end

		WR5: begin
			nxt_state = WR6;
			wr_en = 1'b1;
			wr_data = data_line_in.w5;
		end

		WR6: begin
			nxt_state = WR7;
			wr_en = 1'b1;
			wr_data = data_line_in.w6;
		end

		WR7: begin
			nxt_state = WR_WAIT;
			wr_en = 1'b1;
			wr_data = data_line_in.w7;
		end

		WR_WAIT: begin
			if (write_done) begin
				nxt_state = DONE;
			end else begin
				nxt_state = WR_WAIT;
			end
		end

		RD_LOAD: begin
			nxt_state = RD_WAIT;
			load = 1'b1;
		end

		RD_WAIT: begin
			if (read_done) begin
				nxt_state = RD0;
				sdram_read = 1'b0;
				rd_en = 1'b1;
			end else begin
				nxt_state = RD_WAIT;
				sdram_read = 1'b1;
				rd_en = 1'b0;
			end
		end

		RD0: begin
			nxt_state = RD1;
			rd_index = RDW0;
			rd_en = 1;
		end

		RD1: begin
			nxt_state = RD2;
			rd_index = RDW1;
			rd_en = 1;
		end

		RD2: begin
			nxt_state = RD3;
			rd_index = RDW2;
			rd_en = 1;
		end

		RD3: begin
			nxt_state = RD4;
			rd_index = RDW3;
			rd_en = 1;
		end

		RD4: begin
			nxt_state = RD5;
			rd_index = RDW4;
			rd_en = 1;
		end

		RD5: begin
			nxt_state = RD6;
			rd_index = RDW5;
			rd_en = 1;
		end

		RD6: begin
			nxt_state = RD7;
			rd_index = RDW6;
			rd_en = 1;
		end

		RD7: begin
			nxt_state = DONE;
			rd_index = RDW7;
		end

		DONE: begin
			nxt_state = IDLE;
			done = 1'b1;
		end

		RFS: begin
			if (~about_to_refresh && idle) begin
				nxt_state = IDLE;
			end else begin
				nxt_state = RFS;
			end
		end

		default: begin
			nxt_state = IDLE;
		end
	endcase
end


always_ff @( posedge clk_50m ) begin : load_data
	if (~rst_n) begin
		data_line_out.w0 <= 16'b0;
		data_line_out.w1 <= 16'b0;
		data_line_out.w2 <= 16'b0;
		data_line_out.w3 <= 16'b0;
		data_line_out.w4 <= 16'b0;
		data_line_out.w5 <= 16'b0;
		data_line_out.w6 <= 16'b0;
		data_line_out.w7 <= 16'b0;
	end else begin
		unique case (rd_index)
			RD_DISABLE : begin
				data_line_out.w0 <= data_line_out.w0;
				data_line_out.w1 <= data_line_out.w1;
				data_line_out.w2 <= data_line_out.w2;
				data_line_out.w3 <= data_line_out.w3;
				data_line_out.w4 <= data_line_out.w4;
				data_line_out.w5 <= data_line_out.w5;
				data_line_out.w6 <= data_line_out.w6;
				data_line_out.w7 <= data_line_out.w7;
			end

			RDW0: begin
				data_line_out.w0 <= rd_data;
				data_line_out.w1 <= data_line_out.w1;
				data_line_out.w2 <= data_line_out.w2;
				data_line_out.w3 <= data_line_out.w3;
				data_line_out.w4 <= data_line_out.w4;
				data_line_out.w5 <= data_line_out.w5;
				data_line_out.w6 <= data_line_out.w6;
				data_line_out.w7 <= data_line_out.w7;
			end

			RDW1: begin
				data_line_out.w0 <= data_line_out.w0;
				data_line_out.w1 <= rd_data;
				data_line_out.w2 <= data_line_out.w2;
				data_line_out.w3 <= data_line_out.w3;
				data_line_out.w4 <= data_line_out.w4;
				data_line_out.w5 <= data_line_out.w5;
				data_line_out.w6 <= data_line_out.w6;
				data_line_out.w7 <= data_line_out.w7;
			end

			RDW2: begin
				data_line_out.w0 <= data_line_out.w0;
				data_line_out.w1 <= data_line_out.w1;
				data_line_out.w2 <= rd_data;
				data_line_out.w3 <= data_line_out.w3;
				data_line_out.w4 <= data_line_out.w4;
				data_line_out.w5 <= data_line_out.w5;
				data_line_out.w6 <= data_line_out.w6;
				data_line_out.w7 <= data_line_out.w7;
			end

			RDW3: begin
				data_line_out.w0 <= data_line_out.w0;
				data_line_out.w1 <= data_line_out.w1;
				data_line_out.w2 <= data_line_out.w2;
				data_line_out.w3 <= rd_data;
				data_line_out.w4 <= data_line_out.w4;
				data_line_out.w5 <= data_line_out.w5;
				data_line_out.w6 <= data_line_out.w6;
				data_line_out.w7 <= data_line_out.w7;
			end

			RDW4: begin
				data_line_out.w0 <= data_line_out.w0;
				data_line_out.w1 <= data_line_out.w1;
				data_line_out.w2 <= data_line_out.w2;
				data_line_out.w3 <= data_line_out.w3;
				data_line_out.w4 <= rd_data;
				data_line_out.w5 <= data_line_out.w5;
				data_line_out.w6 <= data_line_out.w6;
				data_line_out.w7 <= data_line_out.w7;
			end

			RDW5: begin
				data_line_out.w0 <= data_line_out.w0;
				data_line_out.w1 <= data_line_out.w1;
				data_line_out.w2 <= data_line_out.w2;
				data_line_out.w3 <= data_line_out.w3;
				data_line_out.w4 <= data_line_out.w4;
				data_line_out.w5 <= rd_data;
				data_line_out.w6 <= data_line_out.w6;
				data_line_out.w7 <= data_line_out.w7;
			end

			RDW6: begin
				data_line_out.w0 <= data_line_out.w0;
				data_line_out.w1 <= data_line_out.w1;
				data_line_out.w2 <= data_line_out.w2;
				data_line_out.w3 <= data_line_out.w3;
				data_line_out.w4 <= data_line_out.w4;
				data_line_out.w5 <= data_line_out.w5;
				data_line_out.w6 <= rd_data;
				data_line_out.w7 <= data_line_out.w7;
			end

			RDW7: begin
				data_line_out.w0 <= data_line_out.w0;
				data_line_out.w1 <= data_line_out.w1;
				data_line_out.w2 <= data_line_out.w2;
				data_line_out.w3 <= data_line_out.w3;
				data_line_out.w4 <= data_line_out.w4;
				data_line_out.w5 <= data_line_out.w5;
				data_line_out.w6 <= data_line_out.w6;
				data_line_out.w7 <= rd_data;
			end

			default: begin
				data_line_out.w0 <= data_line_out.w0;
				data_line_out.w1 <= data_line_out.w1;
				data_line_out.w2 <= data_line_out.w2;
				data_line_out.w3 <= data_line_out.w3;
				data_line_out.w4 <= data_line_out.w4;
				data_line_out.w5 <= data_line_out.w5;
				data_line_out.w6 <= data_line_out.w6;
				data_line_out.w7 <= data_line_out.w7;
			end
		endcase
	end
end

//例化PLL, 产生各模块所需要的时钟
pll_clk u_pll_clk(
    .inclk0             (clk),
    .areset             (~rst_n),
    
    .c0                 (clk_50m),
    .c1                 (clk_100m),
    .c2                 (clk_100m_shift),
    .locked             (locked)
);

//SDRAM 控制器顶层模块,封装成FIFO接口
//SDRAM 控制器地址组成: {bank_addr[1:0],row_addr[12:0],col_addr[8:0]}
//TODO: wr_max_addr, rd_max_addr can be trival value
sdram_top u_sdram_top(
	.ref_clk			(clk_100m),			//sdram	控制器参考时钟
	.out_clk			(clk_100m_shift),	//用于输出的相位偏移时钟
	.rst_n				(sys_rst_n),		//系统复位
    
    //用户写端口
	.wr_clk 			(clk_50m),		    //写端口FIFO: 写时钟
	.wr_en				(wr_en),			//写端口FIFO: 写使能
	.wr_data		    (wr_data),		    //写端口FIFO: 写数据
	.wr_min_addr		(addr),				//写SDRAM的起始地址
	.wr_max_addr		(24'b1),		    //写SDRAM的结束地址
	.wr_len			    (sdram_access_len),	//写SDRAM时的数据突发长度
	.wr_load			(~sys_rst_n || load),//写端口复位: 复位写地址,清空写FIFO
   
    //用户读端口
	.rd_clk 			(clk_50m),			//读端口FIFO: 读时钟
    .rd_en				(rd_en),			//读端口FIFO: 读使能
	.rd_data	    	(rd_data),		    //读端口FIFO: 读数据
	.rd_min_addr		(addr),				//读SDRAM的起始地址
	.rd_max_addr		(24'b1),	   		//读SDRAM的结束地址
	.rd_len 			(sdram_access_len),	//从SDRAM中读数据时的突发长度
	.rd_load			(~sys_rst_n || load),//读端口复位: 复位读地址,清空读FIFO
	   
     //用户控制端口  
	.sdram_read_valid	(sdram_read),		//SDRAM 读使能
	.sdram_init_done	(sdram_init_done),	//SDRAM 初始化完成标志
   
	//SDRAM 芯片接口
	.sdram_clk			(sdram_clk),        //SDRAM 芯片时钟
	.sdram_cke			(sdram_cke),        //SDRAM 时钟有效
	.sdram_cs_n			(sdram_cs_n),       //SDRAM 片选
	.sdram_ras_n		(sdram_ras_n),      //SDRAM 行有效
	.sdram_cas_n		(sdram_cas_n),      //SDRAM 列有效
	.sdram_we_n			(sdram_we_n),       //SDRAM 写有效
	.sdram_ba			(sdram_ba),         //SDRAM Bank地址
	.sdram_addr			(sdram_addr),       //SDRAM 行/列地址
	.sdram_data			(sdram_data),       //SDRAM 数据
	.sdram_dqm			(sdram_dqm)         //SDRAM 数据掩码
    );

endmodule : sdram
