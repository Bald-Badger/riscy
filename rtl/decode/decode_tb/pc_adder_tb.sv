`include "../../opcode.svh"

module pc_adder_tb ();
	
logic rst_n, clk;
logic [XLEN-1:0] instr, pc, rs1, rs2, pc_bj;
logic bj_sel;
logic beq;
logic bne;
logic blt;
logic bltu;
logic bge;
logic bgeu;
integer err_cnt = 0;

pc_adder adder_inst (
    .instr  (instr),
    .pc     (pc),
    .rs1    (rs1),
    .rs2    (rs2),
    .pc_bj  (pc_bj),
    .bj_sel (bj_sel)
);

data_t diff;
//assign diff = adder_inst.rs_diff;

integer  i;

always begin
    #10 clk = ~clk;
end

task init;
    begin						
        rst_n = 1;
        clk = 0;
		instr = 0;
		pc = 0;
		rs1 = 0;
		rs2 = 0;
        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 0;			
        @(negedge clk);
        rst_n = 1;
    end
endtask

task comp;

	rs1 = $random();
	rs2 = $random();
	beq = (rs1 == rs2);
	bne = (rs1 != rs2);
	blt = ($signed(rs1) < $signed(rs2));
	bltu = ($unsigned(rs1) < $unsigned(rs2));
	bge = ($signed(rs1) >= $signed(rs2));
	bgeu = ($unsigned(rs1) >= $unsigned(rs2));
	#1;
	
	assert (beq == adder_inst.beq_take)
	else begin
		err_cnt += 1;
	end

	assert (bne == adder_inst.bne_take)
	else begin
		err_cnt += 1;
	end

	assert (blt == adder_inst.blt_take)
	else begin
		err_cnt += 1;
	end

	assert (bltu == adder_inst.bltu_take)
	else begin
		err_cnt += 1;
	end

	assert (bge == adder_inst.bge_take)
	else begin
		err_cnt += 1;
	end

	assert (bgeu == adder_inst.bgeu_take)
	else begin
		err_cnt += 1;
	end

	@(negedge clk);
	
	
endtask


// BEQ gold
initial begin
	init();

	for (i = 0; i < 1000000 ; i++) begin
		comp();
	end

	$display("tb finished, %d errors", err_cnt);

	$stop();
end

endmodule
