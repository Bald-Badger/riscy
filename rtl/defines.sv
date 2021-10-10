// all defines using in RISCV (except the ones used in alu)

package defines;

`ifndef _defines_sv_
`define _defines_sv_

//	ISA define
	localparam 	XLEN 		= 	32;			// RV32
	localparam	N 			= 	XLEN;	 	// in case I forget should be XLEN instead of N
	localparam 	FREQ 		= 	5e7;		// bus clock, 50Mhz crystal oscillator on FPGA board
	localparam	MEM_SPACE	=	256 - 1;	// memory space in words

//	constant define
	localparam	BYTES 	= XLEN / 8; 		// num of byte in a word
	localparam	TRUE 	= 1;
	localparam	FALSE 	= 0;
	integer 	NULL 	= 32'b0;
	logic		ENABLE 	= 1'b1;
	logic		DISABLE	= 1'b0;

	// sopported extension
	// this part is and only accessed by verilog generate function. 
	localparam	I_SUPPORT		= TRUE;		// Base (Integer) operations, must implement
	localparam	M_SUPPORT		= TRUE;		// Integer Mult / Dvi, should implement
	localparam	A_SUPPORT		= FALSE;	// Atomic instructions, required for xv6
	localparam	F_SUPPORT		= FALSE;	// Single-Precision FP, implement if enough FPGA space
	localparam	D_SUPPORT		= FALSE;	// Double-Precision FP, should not implement
	localparam	Q_SUPPORT		= FALSE;	// Quad-Precision FP, should not implement
	localparam	C_SUPPORT		= FALSE;	// Compressed Instructions, should not implement (unless embedded or VLIW)
	localparam	CSR_SUPPORT		= FALSE;	// Control and status register, required for xv6
	localparam	FENCE_SUPPORT	= FALSE;	// Instruction-Fetch fence, required for xv6


	typedef enum logic[1:0] {
		BLANK_MEM = 2'd0,	// all 0s
		UNINT_MEM = 2'd1,	// all Xs
		INSTR_MEM = 2'd2,	// instrution memory
		DATA_MEM  = 2'd3	// data memory
	} MEM_TYPE_t;


	// Endianess define
	typedef enum logic { 
		LITTLE_ENDIAN = 1'b0,
		BIG_ENDIAN = 1'b1
	} ENDIANESS_t;

	ENDIANESS_t ENDIANESS = BIG_ENDIAN;


	// Opcode define
	typedef enum logic[6:0] { 
		R =			7'b0110011,
		I =			7'b0010011,
		B =			7'b1100011,
		LUI =		7'b0110111,
		AUIPC =		7'b0010111,
		JAL =		7'b1101111,
		JALR =		7'b1100111,
		LOAD =		7'b0000011,
		STORE =		7'b0100011,
		MEM =		7'b0001111,	// for fence instruction
		SYS =		7'b1110011,	// ECALL, EBREAK, and CSR
		ATMO =		7'b0101111, // atomic instr	
		NULL_OP =	7'b0000000
	} opcode_t;


// basic data type define
	typedef logic [XLEN-1:0]	data_t;
	typedef logic [XLEN-1:0]	word_t;
	typedef logic [2*XLEN-1:0]	double_word_t;
	typedef logic [2:0] 		funct3_t;
	typedef logic [6:0] 		funct7_t;
	typedef logic [11:0]		imm_t; // only for I type operation

	typedef enum logic[4:0] {
		X0, X1, X2, X3, X4, X5, X6, X7,
		X8, X9, X10, X11, X12, X13, X14, X15,
		X16, X17, X18, X19, X20, X21, X22, X23,
		X24, X25, X26, X27, X28, X29, X30, X31
	} r_t;


// instruction type define
	typedef struct packed{
		funct7_t	funct7;
		r_t			rs2;
		r_t			rs1;
		funct3_t	funct3;
		r_t			rd;
		opcode_t	opcode;
	} instr_t;		// R (base) type	

	typedef struct packed{
		imm_t		imm;
		r_t			rs1;
		funct3_t	funct3;
		r_t			rd;
		opcode_t	opcode;
	} instr_I_t;		// I type

	instr_t NOP 	= 32'h0000_0013;	// ADDI x0, x0, 0
	instr_t HALT	= 32'h0000_0063;	// BEQ x0, x0, 0
	instr_t EBREAK	= 32'h0000_0073;
	instr_t ECALL	= 32'h0010_0073;
	

// Funt3 define
    // R type funct3
    funct3_t ADD	=	3'b000;		// rd <= rs1 + rs2, no overflow exception
    funct3_t SUB	=	3'b000;		// rd <= rs1 - rs2, no overflow exception
    funct3_t AND	=	3'b111;
    funct3_t OR		=	3'b110;
    funct3_t XOR	=	3'b100;
    funct3_t SLT	=	3'b010;		// set less than, rd <= 1 if rs1 < rs2
    funct3_t SLTU	=	3'b011;		// set less than unsigned, rd <= 1 if rs1 < rs2
    funct3_t SLL	=	3'b001;		// logical shift left, rd <= rs1 << rs2[4:0]
    funct3_t SRL	=	3'b101;		// logical shift right rd <= rs1 >> rs2[4:0]
    funct3_t SRA	=	3'b101;		// arithmetic shift right
	// MUL (same opcode as R) funct3
	funct3_t MUL 	=	3'b000;		// (sign rs1*sign rs2)[XLEN-1:0] => rd
	funct3_t MULH	=	3'b001;		// (sign rs1*sign rs2)[2*XLEN-1:XLEN] => rd
	funct3_t MULHSU	=	3'b010;		// (sign rs1*unsign rs2)[2*XLEN-1:XLEN] => rd
	funct3_t MULHU	=	3'b011;		// (unsign rs1*unsign rs2)[2*XLEN-1:XLEN] => rd
	funct3_t DIV	=	3'b100;		// sign rs1 / sign rs2
	funct3_t DIVU	=	3'b101;		// unsign rs1 / unsign rs2
	funct3_t REM	=	3'b110;		// sign rs1 % sign rs2
	funct3_t REMU	=	3'b111;		// unsign rs1 % unsign rs2

    // I type funct3
    funct3_t ADDI    =	3'b000;
    funct3_t ANDI    =	3'b111;
    funct3_t ORI     =	3'b110;
    funct3_t XORI    =	3'b100;
    funct3_t SLTI    =	3'b010;		// Set less than immediate, rd <= 1 if rs1 < imm
    funct3_t SLTIU   =	3'b011;		// Set less than immediate unsigned, rd <= 1 if rs1 < imm
    funct3_t SLLI    =	3'b001;		// logical shift left imm
    funct3_t SRLI    =	3'b101;		// logical shift right imm
    funct3_t SRAI    =	3'b101;		// arithmetic shift right imm

    // B type funct3                branch imm have to shift left for 1
    funct3_t BEQ     =	3'b000;		// branch if rs1 == rs2
    funct3_t BNE     =	3'b001;		// branch if rs1 != rs2
    funct3_t BLT     =	3'b100;		// branch if rs1 < rs2 signed
    funct3_t BLTU    =	3'b110;		// branch if rs1 < rs2 unsigned
    funct3_t BGE     =	3'b101;		// branch if rs1 >= rs2 signed
    funct3_t BGEU    =	3'b111;		// branch if rs1 >= rs2 unsigned

    // U type have no funct3 
    //funct3_t LUI     =	3'b000;	// rd <= {imm, 12'b0}
    //funct3_t AUIPC   =	3'b000;	// pc, rd <= (pc_of_auipc + {imm, 12'b0})

    // J type have no funct3
    //funct3_t JAL     =	3'b000;	// jump and link, rd <= pc_of_jal + 4, pc <= (pc_of_jal + imm << 1)
    //funct3_t JALR    =	3'b000;	// jump and link registor, rd <= (pc_of_jalr + 4),  
									// pc <= (rs1 + imm) && 0xfffe (set the last bit is always 0)

    // S type funct3 - Load
    funct3_t LB      =	3'b000;		// load 8 bits and sign extend to 32 bits
    funct3_t LH      =	3'b001;		// load 16 bits and sign extend to 32 bits
    funct3_t LW      =	3'b010;		// rd <= mem[rs1 + imm]
    funct3_t LBU     =	3'b100;		// load 8 bits and zero extend to 32 bits
    funct3_t LHU     =	3'b101;		// load 16 bits and zero extend to 32 bits

    // S type funct3 - Store
    funct3_t SB      =	3'b000;      
    funct3_t SH      =	3'b001;
    funct3_t SW      =	3'b010;		// mem[rs1 + imm] <= rs2
    //funct3_t SBU     =	3'b100; not used
    //funct3_t SHU     =	3'b101; not used

    // Fence (Memory ordering) funct3
    funct3_t FENCE	=	3'b000;
	funct3_t FENCEI	=	3'b001;	

	// SYS (ECALL, EBREAK, and CSR) funct3
	funct3_t CSRRW =	3'b001;	// Atomic read/write CSR
	funct3_t CSRRS =	3'b010;	// Atomic Read and Clear Bits
	funct3_t CSRRC =	3'b011;
	funct3_t CSRRWI =	3'b101;
	funct3_t CSRRSI =	3'b110;
	funct3_t CSRRCI =	3'b111;

	// ATMO (atomic instruction) funct3
	// TODO: implement


// funct7 define (R only)
	funct7_t M_INSTR = 7'b000_0001;

	// little endian mask (and-mask, not or-mask)
	logic[XLEN-1:0] B_MASK_LITTLE = 32'hFF_00_00_00;
	logic[XLEN-1:0] H_MASK_LITTLE = 32'hFF_FF_00_00;
	logic[XLEN-1:0] W_MASK_LITTLE = 32'hFF_FF_FF_FF;
	logic[BYTES-1:0] B_EN_LITTLE = 4'b1000;
	logic[BYTES-1:0] H_EN_LITTLE = 4'b1100;
	logic[BYTES-1:0] W_EN_LITTLE = 4'b1111;

	// big endian mask (and-mask, not or-mask)
	logic[XLEN-1:0] B_MASK_BIG = 32'h00_00_00_FF;
	logic[XLEN-1:0] H_MASK_BIG = 32'h00_00_FF_FF;
	logic[XLEN-1:0] W_MASK_BIG = 32'hFF_FF_FF_FF;
	logic[BYTES-1:0] B_EN_BIG = 4'b0001;
	logic[BYTES-1:0] H_EN_BIG = 4'b0011;
	logic[BYTES-1:0] W_EN_BIG = 4'b1111;

function data_t sign_extend;
	input imm_t imm;
	return data_t'({imm[11]*20, imm[11:0]});
endfunction


function data_t get_imm;
	input instr_t instr;
	unique case (instr.opcode)
		LUI:		return data_t'({instr[31:12], 12'b0});
		AUIPC:		return data_t'({instr[31:12], 12'b0});
		JAL:		return data_t'({32'd4});	// pc + 4 for ALU
		JALR:		return data_t'({32'd4});	// pc + 4 for ALU
		B:			return data_t'({ {20{instr[31]}} , instr[7], instr[30:25], instr[11:8], 1'b0});
		LOAD:		return data_t'({ {20{instr[31]}} , instr[31:20]});
		STORE:		return data_t'({ {20{instr[31]}} , instr[31:25], instr[11:7]});
		I:			return data_t'({ {20{instr[31]}} , instr[31:20]});
		default:	return NULL;
	endcase
endfunction

function data_t swap_endian;
	input data_t data;
	return	data_t'	({{data[07:00]},
            		{data[15:08]},
            		{data[23:16]},
            		{data[31:24]}});
endfunction

// fwd mux ctrl signal types
typedef enum logic[1:0] {
	RS_SEL 			= 2'b00,
	MEM_MEM_FWD_SEL = 2'b01,
	EX_EX_FWD_SEL 	= 2'b10,
	MEM_EX_FWD_SEL	= 2'b11
} fwd_sel_t;

typedef enum logic[1:0] {
	B_RS_SEL	= 2'b00,
	B_EX_SEL	= 2'b01,
	B_MEM_SEL	= 2'b10,
	B_WB_SEL	= 2'b11
} branch_fwd_t;


typedef enum logic[1:0] {
	RS_STORE_SEL	= 2'b00,
	EX_ID_STORE_SEL	= 2'b01,
	MEM_ID_STORE_SEL= 2'b10,
	WB_ID_STORE_SEL	= 2'b11
} store_fwd_t;


// register names
r_t ZERO	= X0;
r_t RA		= X1;
r_t SP		= X2;
r_t GP		= X3; 
r_t TP		= X4; 
r_t T0		= X5; 
r_t T1		= X6; 
r_t T2		= X7;
r_t S0		= X8; 
r_t S1		= X9; 
r_t A0		= X10; 
r_t A1		= X11; 
r_t A2		= X12; 
r_t A3		= X13; 
r_t A4		= X14; 
r_t A5		= X15;
r_t A6		= X16;
r_t A7		= X17;
r_t S2		= X18;
r_t S3		= X19; 
r_t S4		= X20; 
r_t S5		= X21; 
r_t S6		= X22;
r_t S7		= X23;
r_t S8		= X24;
r_t S9		= X25; 
r_t S10		= X26; 
r_t S11		= X27;
r_t T3		= X28;
r_t T4		= X29;
r_t T5		= X30;
r_t T6		= X31;

`endif

endpackage : defines
