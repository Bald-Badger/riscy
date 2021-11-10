/*
This is the module that monitors if any other hart have changed 
the value in some memory location that holds a lock
*/

import defines::*;

module exclusive_monitor #(
	RES_ENTRY_CNT = MAX_NEST_LOCK
) (
	input	logic		clk,
	input	logic		rst_n,
    input   instr_a_t	instr,
	input	data_t		addr,
	input	logic		mem_wr,
	input	logic		update,	// up only one cycle
	output	logic		success
);
	
	typedef struct packed{
		data_t	addr;
		logic	valid;
	} reservation_set_t;

	reservation_set_t	reservation_set		[MAX_NEST_LOCK - 1 : 0];	// a stack of reservation stack
	logic [$clog2(MAX_NEST_LOCK) - 1 : 0]	pointer;					// pointer to the newest reservation stack
	logic set_valid, clear_valid;
	logic push, pop;

	opcode_t	opcode;
	funct5_t	funct5;
	logic		is_atomic, is_lc, is_sc;
	
	
	always_comb begin : ctrl_signal_assign
		opcode		=	instr.opcode;
		funct5		=	instr.funct5;
		is_atomic	=	opcode == ATOMIC;
		is_lc		=	is_atomic && funct5 == LC;
		is_sc		=	is_atomic && funct5 == SC;
		set_valid	=	is_lc;
		clear_valid	=	(
							mem_wr && 
							(addr == reservation_set[pointer].addr) && 
							reservation_set[pointer].valid
						) ||
						is_sc;
		push		=	is_lc;
		pop			=	is_sc;
		success		=	is_sc &&
						(addr == reservation_set[pointer].addr) && 
						reservation_set[pointer].valid;
	end


	always_ff @(posedge clk, negedge rst_n) begin
		if (~rst_n) begin
			pointer <= 4'b0;
		end else if (push && update) begin
			pointer <= pointer + 4'b1;
		end else if (pop && update) begin
			pointer <= pointer - 4'b1;
		end else begin
			pointer <= pointer;
		end
	end


	integer i;
	always_ff @(posedge clk, negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < MAX_NEST_LOCK; i++) begin
				reservation_set[i].addr			<= NULL;
				reservation_set[i].valid		<= INVALID;
			end
		end else if (set_valid && update) begin
			for (i = 0; i < MAX_NEST_LOCK; i++) begin
				if (i == pointer) begin
					reservation_set[i].addr		<= addr;
					reservation_set[i].valid	<= VALID;
				end else begin
					reservation_set[i].addr		<= reservation_set[i].addr;
					reservation_set[i].valid	<= reservation_set[i].valid;
				end
			end
		// an regular st/ld without 'update' bit set can also trigger clear valid
		end else if (clear_valid && update) begin
			for (i = 0; i < MAX_NEST_LOCK; i++) begin
				if (i == pointer) begin
					reservation_set[i].addr		<= NULL;
					reservation_set[i].valid	<= INVALID;
				end else begin
					reservation_set[i].addr		<= reservation_set[i].addr;
					reservation_set[i].valid	<= reservation_set[i].valid;
				end
			end
		end else begin
			for (i = 0; i < MAX_NEST_LOCK; i++) begin
				reservation_set[i].addr			<= reservation_set[i].addr;
				reservation_set[i].valid		<= reservation_set[i].valid;
			end
		end
	end


endmodule : exclusive_monitor

// TODO: constraint: ld must followed by a st at same addr, ld must not followed by another ld
