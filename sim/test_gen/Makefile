# -g: enable gdb symbols
# -wall: enable all warnings
# -O0: only optimization for compilation time
# -mdiv: use hardware int division
# -mno-fdiv: do not use hardware fp div
# -no-pie: don't make position independent executable (PIE)
# -mstrict-align: Do not generate unaligned memory accesses
# -mlittle-endian: generate little endian code
# -march=rv32im: rv32im ISA
# -mabi=ilp32: 32 bit data type without fp
# -lstdc++: enable c++ compile
# -mbranch-cost=1: low branch cost, so hopefully disable instruction reorder
# -mexplicit-relocs: use assembler relocation operators when dealing with symbolic addresses, hopefully reduce pseudo instruction
CFLAGS = -Wall -O0 -mdiv -mno-fdiv -no-pie -mstrict-align -mlittle-endian -march=rv32im -mabi=ilp32 -lstdc++ -mbranch-cost=1 -mexplicit-relocs
GCC = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy
OBJDUMP = riscv64-unknown-elf-objdump
COPYFLAGS = -O binary
# --only-section=.text
TARGET = ./test
TBTARGET = instr
SRC = $(TARGET).c
SDEST = $(TBTARGET).s
JAVA = java
RARSADDR = 0x00000000-0x00008000
JAVAFLAGS = -jar rars.jar a mc CompactTextAtZero dump $(RARSADDR) HexText
PYTHON = python
READELF = riscv64-unknown-elf-readelf
DASM = ./riscvdasm

all: clean offset

# build the .S assembly file
asm:
	$(GCC) $(CFLAGS) -S $(SRC) -o $(SDEST)

# build the compiled and linked elf file	
elf: asm
	$(GCC) $(CFLAGS) $(SRC) -o $(TARGET)

# extract the executable binary from elf
bin: elf
	$(OBJCOPY) $(COPYFLAGS) $(TARGET) $(TBTARGET).bin

# build memory init file from binary, only used for Altera memory init
mif: bin
	$(PYTHON) ./bin2mif.py $(TBTARGET).bin $(TBTARGET).mif 32

# extract elf header info from elf file
header: elf
	$(READELF) -h $(TARGET) >> $(TARGET).header

# extract section information from elf file
section: elf
	$(READELF) -S $(TARGET) >> $(TARGET).section

# extract the .text segment asm from elf
text: elf
	$(OBJDUMP) -dj .text $(TARGET) > instr_full.s 
# --no-address --no-show-raw-insn

# extract the all segments from elf to .S file
full: elf
	$(OBJDUMP) -D $(TARGET) > instr_full.s 

# extract the data segment from elf
data: elf
	$(OBJDUMP) -dj .data $(TARGET) > instr_data.s 

# calculate entry point pc offset
offset: header section full bin
	$(PYTHON) ./get_off.py

# 3rd party bin disassembler, deprecated
dasm: bin
	$(DASM) < $(TBTARGET).bin > dasm.s

# using RARS to compile .S file into machine code, deprecated
rars_mc: clean asm 
	$(JAVA) $(JAVAFLAGS) $(TARGET).mc $(TARGET).s

# using RARS to compule .S file to mif file, deprecated
rars: rars_mc
	$(PYTHON) ./mc2mif.py -i $(TARGET).mc -o $(TBTARGET).mif

# delete all but .c, .h file
clean:
	rm -f ./*.s $(TARGET) ./*.bin ./*.mif ./*.mc ./*.header ./*.section ./*.cfg
