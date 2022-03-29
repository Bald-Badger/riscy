package defines;

`ifndef _defines_sv_
`define _defines_sv_

//	generate synthesizable code if set
	`define		SYNTHESIZE

// hardware target
	typedef enum logic [1:0] {
		INDEPNDENT,
		ALTERA,
		XILINX
	} target_t;

	localparam [1:0]	TARGET	= ALTERA;

//	ISA define
	localparam 	XLEN 			= 32;				// RV32
	localparam	N 				= XLEN;	 			// in case I forget should be XLEN instead of N
	localparam 	OSC_FREQ 		= 5e7;				// 50Mhz crystal oscillator on FPGA board
	localparam 	FREQ 			= 1e9;				// targeted core clock from PLL


//	core config
	localparam	MAX_NEST_LOCK	= 8;				// max nested lock aquire length, 
													// cases that over 2 is very rare
	localparam	SP_BASE			= 32'h0000_3ffc;	// stack base pointer, init SP to here
	localparam	GP_BASE			= 32'h0000_1800;	// global pointer, init GP to here


// TB config
	localparam	TB_TIMEOUT		= 2333333;			// test timeout in clock cycles
													// testbench will end after this time is reached

//	constant define
	localparam	BYTES 			= XLEN / 8; 		// number of bytes in a word
	localparam	TRUE 			= 1;
	localparam	FALSE 			= 0;
	localparam 	NULL 			= 32'b0;			// used to repersent blank data
	localparam	ENABLE 			= 1'b1;
	localparam	DISABLE			= 1'b0;
	localparam	VALID			= 1'b1;
	localparam	INVALID			= 1'b0;
	localparam	READY			= 1'b1;
	localparam	DONE			= 1'b1;
	localparam	SET				= 1'b1;
	localparam	CLEAR			= 1'b0;


//	debug log option
	localparam	TOP_DEBUG		= ENABLE;

	// byte-varient endianess
	localparam LITTLE_ENDIAN	= 1'b0;
	localparam BIG_ENDIAN		= 1'b1;
	localparam ENDIANESS		= LITTLE_ENDIAN;	// as commonly used in modern computer system


	// sopported extension
	// this part shoule be only accessed by generate
	localparam	I_SUPPORT		= TRUE;		// Base (Integer) operations, must implement
	localparam	M_SUPPORT		= FALSE;	// Integer Mult / Dvi, should implement
	localparam	Z_SUPPORT		= FALSE;	// Instruction-Fetch fence, required for xv6
	localparam	A_SUPPORT		= FALSE;	// Atomic instructions, required for xv6
	localparam	F_SUPPORT		= FALSE;	// Single-Precision FP, implement if enough FPGA space
	localparam	D_SUPPORT		= FALSE;	// Double-Precision FP, should not implement
	localparam	Q_SUPPORT		= FALSE;	// Quad-Precision FP, should not implement
	localparam	C_SUPPORT		= FALSE;	// Compressed Instructions, should not implement
	localparam	CSR_SUPPORT		= FALSE;	// Control and status register, required for xv6


	// boot options
	typedef enum logic[1:0] {
		BINARY_BOOT,	// boot from a bin file generated from gcc
		RARS_BOOT		// boot from a rars compiled mif file
	} boot_type_t;
	localparam	[1:0] BOOT_TYPE = BINARY_BOOT;


	// branch predictor
	typedef enum logic[1:0] {
		P_TAKEN,		// predict taken
		P_N_TAKEN,		// predict not taken
		BTFNT			// back taken forward not taken
	} branch_predictor_t;
	localparam	[1:0] PREDICTOR = P_N_TAKEN;
	localparam	TAKEN = 1'b1;
	localparam	NOT_TAKEN = 1'b0;

	// Opcode define
	typedef enum logic[6:0] { 
		R		=	7'b0110011,
		I		=	7'b0010011,
		B		=	7'b1100011,
		LUI		=	7'b0110111,
		AUIPC	=	7'b0010111,
		JAL		=	7'b1101111,
		JALR	=	7'b1100111,
		LOAD	=	7'b0000011,
		STORE	=	7'b0100011,
		MEM		=	7'b0001111,	// for fence instruction
		SYS		=	7'b1110011,	// ECALL, EBREAK, and CSR
		ATOMIC	=	7'b0101111, // atomic instr	
		NULL_OP	=	7'b0000000
	} opcode_t;


// basic data type define
	typedef logic [XLEN-1:0]	data_t;
	typedef logic [7:0]			byte_t;
	typedef logic [15:0]		half_word_t;
	typedef logic [2:0] 		funct3_t;
	typedef logic [6:0] 		funct7_t;
	typedef logic [11:0]		imm_t;		// only for I type instruction


	typedef struct packed {
		byte_t b0;
		byte_t b1;
		byte_t b2;
		byte_t b3;
	} word_t;

	typedef enum logic[4:0] {
		X0, X1, X2, X3, X4, X5, X6, X7,
		X8, X9, X10, X11, X12, X13, X14, X15,
		X16, X17, X18, X19, X20, X21, X22, X23,
		X24, X25, X26, X27, X28, X29, X30, X31
	} r_t;	// simulator should assign 5'd0 - 5'd31 in order


	localparam	[XLEN-1:0]	NOP		= 32'h0000_0013;	// ADDI x0, x0, 0
	// localparam	[XLEN-1:0]	HALT	= 32'h0000_0063;// BEQ x0, x0, 0
	localparam	[XLEN-1:0]	EBREAK	= 32'h0010_0073;
	localparam	[XLEN-1:0]	ECALL	= 32'h0000_0073;
	

// Funt3 define
	// R type funct3
	localparam	[2:0]	ADD			=	3'b000;		// rd <= rs1 + rs2, no overflow exception
	localparam	[2:0]	SUB			=	3'b000;		// rd <= rs1 - rs2, no overflow exception
	localparam	[2:0]	AND			=	3'b111;
	localparam	[2:0]	OR			=	3'b110;
	localparam	[2:0]	XOR			=	3'b100;
	localparam	[2:0]	SLT			=	3'b010;		// set less than, rd <= 1 if rs1 < rs2
	localparam	[2:0]	SLTU		=	3'b011;		// set less than unsigned, rd <= 1 if rs1 < rs2
	localparam	[2:0]	SLL			=	3'b001;		// logical shift left, rd <= rs1 << rs2[4:0]
	localparam	[2:0]	SRL			=	3'b101;		// logical shift right rd <= rs1 >> rs2[4:0]
	localparam	[2:0]	SRA			=	3'b101;		// arithmetic shift right
	// MUL (same opcode as R) funct3
	localparam	[2:0]	MUL			=	3'b000;		// (sign rs1*sign rs2)[XLEN-1:0] => rd
	localparam	[2:0]	MULH		=	3'b001;		// (sign rs1*sign rs2)[2*XLEN-1:XLEN] => rd
	localparam	[2:0]	MULHSU		=	3'b010;		// (sign rs1*unsign rs2)[2*XLEN-1:XLEN] => rd
	localparam	[2:0]	MULHU		=	3'b011;		// (unsign rs1*unsign rs2)[2*XLEN-1:XLEN] => rd
	localparam	[2:0]	DIV			=	3'b100;		// sign rs1 / sign rs2
	localparam	[2:0]	DIVU		=	3'b101;		// unsign rs1 / unsign rs2
	localparam	[2:0]	REM			=	3'b110;		// sign rs1 % sign rs2
	localparam	[2:0]	REMU		=	3'b111;		// unsign rs1 % unsign rs2

	// I type funct3
	localparam	[2:0]	ADDI		=	3'b000;
	localparam	[2:0]	ANDI		=	3'b111;
	localparam	[2:0]	ORI			=	3'b110;
	localparam	[2:0]	XORI		=	3'b100;
	localparam	[2:0]	SLTI		=	3'b010;		// Set less than immediate, rd <= 1 if rs1 < imm
	localparam	[2:0]	SLTIU		=	3'b011;		// Set less than immediate unsigned, rd <= 1 if rs1 < imm
	localparam	[2:0]	SLLI		=	3'b001;		// logical shift left imm
	localparam	[2:0]	SRLI		=	3'b101;		// logical shift right imm
	localparam	[2:0]	SRAI		=	3'b101;		// arithmetic shift right imm

	// B type funct3				branch imm have to shift left for 1
	localparam	[2:0]	BEQ			=	3'b000;		// branch if rs1 == rs2
	localparam	[2:0]	BNE			=	3'b001;		// branch if rs1 != rs2
	localparam	[2:0]	BLT			=	3'b100;		// branch if rs1 < rs2 signed
	localparam	[2:0]	BLTU		=	3'b110;		// branch if rs1 < rs2 unsigned
	localparam	[2:0]	BGE			=	3'b101;		// branch if rs1 >= rs2 signed
	localparam	[2:0]	BGEU		=	3'b111;		// branch if rs1 >= rs2 unsigned

	// U type have no funct3 
	//localparam	[2:0]	LUI		=	3'b000;	// rd <= {imm, 12'b0}
	//localparam	[2:0]	AUIPC	=	3'b000;	// pc, rd <= (pc_of_auipc + {imm, 12'b0})

	// J type have no funct3
	//localparam	[2:0]	JAL		=	3'b000;	// jump and link, rd <= pc_of_jal + 4, pc <= (pc_of_jal + imm << 1)
	//localparam	[2:0]	JALR	=	3'b000;	// jump and link registor, rd <= (pc_of_jalr + 4),  
												// pc <= (rs1 + imm) && 0xfffe (set the last bit is always 0)

	// S type funct3 - Load
	localparam	[2:0]	LB			=	3'b000;		// load 8 bits and sign extend to 32 bits
	localparam	[2:0]	LH			=	3'b001;		// load 16 bits and sign extend to 32 bits
	localparam	[2:0]	LW			=	3'b010;		// rd <= mem[rs1 + imm]
	localparam	[2:0]	LBU			=	3'b100;		// load 8 bits and zero extend to 32 bits
	localparam	[2:0]	LHU			=	3'b101;		// load 16 bits and zero extend to 32 bits

	// S type funct3 - Store
	localparam	[2:0]	SB			=	3'b000;		// mem[rs1 + imm] <= rs2.byte0
	localparam	[2:0]	SH			=	3'b001;		// mem[rs1 + imm] <= rs2.word0
	localparam	[2:0]	SW			=	3'b010;		// mem[rs1 + imm] <= rs2
	//localparam	[2:0]	SBU	 =	3'b100; not used
	//localparam	[2:0]	SHU	 =	3'b101; not used

	// Fence (Memory ordering) funct3
	localparam	[2:0]	FENCE		=	3'b000;
	localparam	[2:0]	FENCEI		=	3'b001;	

	// Atomic funct3
	localparam	[2:0]	A_32		=	3'b010;
	localparam	[2:0]	A_64		=	3'b011;	// not supported

	// SYS (ECALL, EBREAK, and CSR) funct3
	localparam	[2:0]	CSRRW		=	3'b001;	// Atomic read/write CSR
	localparam	[2:0]	CSRRS		=	3'b010;	// Atomic Read and Clear Bits
	localparam	[2:0]	CSRRC		=	3'b011;
	localparam	[2:0]	CSRRWI		=	3'b101;
	localparam	[2:0]	CSRRSSI		=	3'b110;
	localparam	[2:0]	CSRRCI		=	3'b111;

// funct5 define (Atomic only)
	typedef enum logic[4:0] { 
		LR			=	5'b00010,	// load-reserved
		SC			=	5'b00011,	// store-conditional
		AMOSWAP		=	5'b00001,	// rd <= mem[rs1], mem[rs1] <= rs2(old)
		AMOADD		=	5'b00000,	// rd <= mem[rs1], mem[rs1] <= rs2(old) + rd
		AMOXOR		=	5'b00100,
		AMOAND		=	5'b01100,
		AMOOR		=	5'b01000,
		AMOMIN		=	5'b10000,
		AMOMAX		=	5'b10100,
		AMOMINU		=	5'b11000,
		AMOMAXU		=	5'b11100
	} funct5_t; // only for ATOMIC instruction


// funct7 define (R only)
	localparam	[6:0]	M_INSTR		= 7'b000_0001;	// indicate this R type instruction is mult or div

	// little endian mask
	localparam	[XLEN-1:0]	B_MASK_LITTLE = 32'hFF_00_00_00;
	localparam	[XLEN-1:0]	H_MASK_LITTLE = 32'hFF_FF_00_00;
	localparam	[XLEN-1:0]	W_MASK_LITTLE = 32'hFF_FF_FF_FF;
	localparam	[BYTES-1:0]	B_EN_LITTLE = 4'b1000;
	localparam	[BYTES-1:0] H_EN_LITTLE = 4'b1100;
	localparam	[BYTES-1:0] W_EN_LITTLE = 4'b1111;

	// big endian mask
	localparam	[XLEN-1:0]	B_MASK_BIG = 32'h00_00_00_FF;
	localparam	[XLEN-1:0]	H_MASK_BIG = 32'h00_00_FF_FF;
	localparam	[XLEN-1:0]	W_MASK_BIG = 32'hFF_FF_FF_FF;
	localparam	[BYTES-1:0]	B_EN_BIG = 4'b0001;
	localparam	[BYTES-1:0]	H_EN_BIG = 4'b0011;
	localparam	[BYTES-1:0]	W_EN_BIG = 4'b1111;


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
	} instr_i_t;	// I type

	typedef struct packed{
		logic[11:5]	imm_h;
		r_t			rs2;
		r_t			rs1;
		funct3_t	funct3;
		logic[4:0]	imm_l;
		opcode_t	opcode;
	} instr_s_t;	// S type

	typedef struct packed {
		funct5_t	funct5;
		logic		aq;
		logic		rl;
		r_t			rs2;
		r_t			rs1;
		funct3_t	funct3;
		r_t			rd;
		opcode_t	opcode;
	} instr_a_t;	// Atomic type


function data_t sign_extend;	// sign extend 12bit imm
	input imm_t imm;
	return data_t'({ {20{imm[11]}}, {imm[11:0]} });
endfunction


function data_t sign_extend_h;	// sign extend 16-bit half word
	input half_word_t imm;
	return data_t'({ {16{imm[15]}}, {imm[15:0]} });
endfunction


function data_t sign_extend_b;	// sign extend 8 bit byte
	input byte_t imm;
	return data_t'({ {24{imm[7]}}, {imm[7:0]} });
endfunction


function data_t zero_extend;	// zero extend 12bit imm
	input imm_t imm;
	return data_t'({ {20'b0}, {imm[11:0]} });
endfunction


function data_t zero_extend_h;	// zero extend 16-bit half word
	input half_word_t imm;
	return data_t'({ {16'b0}, {imm[15:0]} });
endfunction


function data_t zero_extend_b;	// zero extend 8 bit byte
	input byte_t imm;
	return data_t'({ {24'b0}, {imm[7:0]} });
endfunction


function data_t get_imm;		// extract immidiate value from instruction
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
	return	data_t'	({{data[7:0]},
					{data[15:8]},
					{data[23:16]},
					{data[31:24]}});
endfunction


// fwd mux ctrl signal types
typedef enum logic[1:0] {
	RS_ID_SEL	= 2'b00,
	EX_ID_SEL	= 2'b01,
	MEM_ID_SEL	= 2'b10,
	WB_ID_SEL	= 2'b11
} id_fwd_sel_t;


typedef enum logic[1:0] {
	RS_EX_SEL	= 2'b00,
	MEM_EX_SEL	= 2'b01,
	WB_EX_SEL	= 2'b10
} ex_fwd_sel_t;


typedef enum logic[1:0] {
	RS_MEM_SEL	= 2'b00,
	WB_MEM_SEL	= 2'b01
} mem_fwd_sel_t;


// sometimes i mistype "$stop()" as "stop()"...
function void stop;	
	$stop();
endfunction


// register names
localparam	[4:0]	ZERO	= X0;
localparam	[4:0]	RA		= X1;
localparam	[4:0]	SP		= X2;
localparam	[4:0]	GP		= X3; 
localparam	[4:0]	TP		= X4; 
localparam	[4:0]	T0		= X5; 
localparam	[4:0]	T1		= X6; 
localparam	[4:0]	T2		= X7;
localparam	[4:0]	S0		= X8; 
localparam	[4:0]	S1		= X9; 
localparam	[4:0]	A0		= X10; 
localparam	[4:0]	A1		= X11; 
localparam	[4:0]	A2		= X12; 
localparam	[4:0]	A3		= X13; 
localparam	[4:0]	A4		= X14; 
localparam	[4:0]	A5		= X15;
localparam	[4:0]	A6		= X16;
localparam	[4:0]	A7		= X17;
localparam	[4:0]	S2		= X18;
localparam	[4:0]	S3		= X19; 
localparam	[4:0]	S4		= X20; 
localparam	[4:0]	S5		= X21; 
localparam	[4:0]	S6		= X22;
localparam	[4:0]	S7		= X23;
localparam	[4:0]	S8		= X24;
localparam	[4:0]	S9		= X25; 
localparam	[4:0]	S10		= X26; 
localparam	[4:0]	S11		= X27;
localparam	[4:0]	T3		= X28;
localparam	[4:0]	T4		= X29;
localparam	[4:0]	T5		= X30;
localparam	[4:0]	T6		= X31;

`endif

endpackage : defines
