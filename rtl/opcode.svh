`ifndef _opceode_vh_
`define _opceode_vh_


//	constant define
	localparam	N = 	32;	 // in case I forget should be XLEN instead of N
	localparam 	XLEN = 	32;
	integer 	NULL =	0;

	// Opcode define
	typedef enum logic[6:0] { 
		R =				7'b0110011,
		I =				7'b0010011,
		B =				7'b1100011,
		LUI =			7'b0110111,
		AUIPC =			7'b0010111,
		JAL =			7'b1101111,
		JALR =			7'b1100111,
		LOAD =			7'b0000011,
		STORE =			7'b0100011,
		MEM =			7'b0001111,	// for fence instruction
		SYS =			7'b1110011,	// for ECALL and  EBREAK
		NULL_OPCODE =	7'b0000000
	} opcode_t;


// basic data type define
	typedef logic[XLEN-1:0]	data_t;
	typedef logic[2:0] 		funct3_t;
	typedef logic[6:0] 		funct7_t;
	//typedef logic[11:0]		funct12_t;
	typedef logic[4:0] 		r_t;


// instruction type define

	typedef struct packed{
		funct7_t	funct7;
		r_t			rs2;
		r_t			rs1;
		funct3_t	funct3;
		r_t			rd;
		opcode_t	opcode;
	} instr_t;		// same as R type


// Funt3 define
    // R type funt3
    funct3_t ADD     =	3'b000;
    funct3_t SUB     =	3'b000;
    funct3_t AND     =	3'b111;
    funct3_t OR      =	3'b110;
    funct3_t XOR     =	3'b100;
    funct3_t SLT     =	3'b010;		// set less than, rd <= 1 if rs1 < rs2
    funct3_t SLTU    =	3'b011;		// set less than unsigned, rd <= 1 if rs1 < rs2
    funct3_t SLL     =	3'b001;		// logical shift left
    funct3_t SRL     =	3'b101;		// logical shift right
    funct3_t SRA     =	3'b101;		// arithmetic shift right

    // I type funt3
    funct3_t ADDI    =	3'b000;
    funct3_t ANDI    =	3'b111;
    funct3_t ORI     =	3'b110;
    funct3_t XORI    =	3'b100;
    funct3_t SLTI    =	3'b010;		// Set less than immediate, rd <= 1 if rs1 < imm
    funct3_t SLTIU   =	3'b011;		// Set less than immediate unsigned, rd <= 1 if rs1 < imm
    funct3_t SLLI    =	3'b001;		// logical shift left imm
    funct3_t SRLI    =	3'b101;		// logical shift right imm
    funct3_t SRAI    =	3'b101;		// arithmetic shift right imm

    // B type funt3                branch imm have to shift left for 1
    funct3_t BEQ     =	3'b000;		// branch if rs1 == rs2
    funct3_t BNE     =	3'b001;		// branch if rs1 != rs2
    funct3_t BLT     =	3'b100;		// branch if rs1 < rs2 signed
    funct3_t BLTU    =	3'b110;		// branch if rs1 < rs2 unsigned
    funct3_t BGE     =	3'b101;		// branch if rs1 >= rs2 signed
    funct3_t BGEU    =	3'b111;		// branch if rs1 >= rs2 unsigned

    // U type have no funt3 
    //funct3_t LUI     =	3'b000;	// rd <= {imm, 12'b0}
    //funct3_t AUIPC   =	3'b000;	// pc, rd <= (pc_of_auipc + {imm, 12'b0})

    // J type have no funt3
    //funct3_t JAL     =	3'b000;	// jump and link, rd <= pc_of_jal + 4, pc <= (pc_of_jal + imm << 1)
    //funct3_t JALR    =	3'b000;	// jump and link registor, rd <= (pc_of_jalr + 4),  pc <= (rs1 + imm) && 0xfffe (set the last bit is always 0)

    // S type funt3 - Load
    funct3_t LB      =	3'b000;		// load 8 bits and sign extend to 32 bits
    funct3_t LH      =	3'b001;		// load 16 bits and sign extend to 32 bits
    funct3_t LW      =	3'b010;		// rd <= mem[rs1 + imm]
    funct3_t LBU     =	3'b100;		// load 8 bits and sign extend to 32 bits
    funct3_t LHU     =	3'b101;		// load 16 bits and zero extend to 32 bits

    // S type funt3 - Store
    funct3_t SB      =	3'b000;      
    funct3_t SH      =	3'b001;
    funct3_t SW      =	3'b010;		// mem[rs1 + imm] <= rs2
    //funct3_t SBU     =	3'b100; not used
    //funct3_t SHU     =	3'b101; not used

    // Fence (Memory ordering) funt3
    funct3_t FENCE   =	3'b000;


// instructon extraction functions

function r_t get_rs2;
	input instr_t instr;
	return r_t'(instr.rs2);
endfunction

function r_t get_rs1;
	input instr_t instr;
	return r_t'(instr.rs1);
endfunction

function funct3_t get_funct3;
	input instr_t instr;
	return funct3_t'(instr.funct3);
endfunction

function r_t get_rd;
	input instr_t instr;
	return r_t'(instr.rd);
endfunction

function opcode_t get_opcode;
	input instr_t instr;
	return opcode_t'(instr.opcode);
endfunction

function data_t get_imm;
	input instr_t instr;
	unique	if(instr.opcode == LUI)		return data_t'({instr[31:12], 12'b0});
	else 	if(instr.opcode == AUIPC)	return data_t'({instr[31:12], 12'b0});
	else 	if(instr.opcode == JAL)		return data_t'({32'd4});	// pc + 4 for ALU
	else 	if(instr.opcode == JALR)	return data_t'({32'd4});	// pc + 4 for ALU
	else 	if(instr.opcode == B)		return data_t'({instr[31]*20, instr[7], instr[30:25], instr[11:8], 1'b0});
	else 	if(instr.opcode == LOAD)	return data_t'({instr[31]*20, instr[31:20]});
	else 	if(instr.opcode == STORE)	return data_t'({instr[31]*20, instr[31:25], instr[11:7]});
	else 	if(instr.opcode == I)		return data_t'({instr[31]*20, instr[31:20]});
	else 								return data_t'(NULL);
endfunction


`endif
