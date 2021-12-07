GCC = riscv64-unknown-elf-gcc
CFLAGS = -Wall -O0 -mdiv -mno-fdiv -no-pie -mstrict-align -mlittle-endian -march=rv32im -mabi=ilp32 -lstdc++ -mbranch-cost=1 -mexplicit-relocs
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

OBJCOPY = riscv64-unknown-elf-objcopy
COPYFLAGS = -O binary --only-section=.text
TARGET = ./test
TBTARGET = instr
SRC = $(TARGET).c
SDEST = $(TBTARGET).s
JAVA = java
RARSADDR = 0x00000000-0x00008000
JAVAFLAGS = -jar rars.jar a mc CompactTextAtZero dump $(RARSADDR) HexText
PYTHON = python
READELF = riscv64-unknown-elf-readelf

all: clean asm elf bin mif offset

# build the .S assembly file
asm:
	$(GCC) $(CFLAGS) -S $(SRC) -o $(SDEST)

# build the compiled and linked elf file	
elf:
	$(GCC) $(CFLAGS) $(SDEST) -o $(TARGET)

# extract the executable binary from elf
bin:
	$(OBJCOPY) $(COPYFLAGS) $(TARGET) $(TBTARGET).bin

# build memory init file from binary
mif:
	$(PYTHON) ./bin2mif.py $(TBTARGET).bin $(TBTARGET).mif 32

# extract elf header info from elf file
header:
	$(READELF) -h $(TARGET) >> $(TARGET).header

# extract section information from elf file
section:
	$(READELF) -S $(TARGET) >> $(TARGET).section

# calculate entry point pc offset
offset: header section asm elf
	$(PYTHON) ./get_off.py

rars_mc: clean asm 
	$(JAVA) $(JAVAFLAGS) $(TARGET).mc $(TARGET).s

rars: rars_mc
	$(PYTHON) ./mc2mif.py -i $(TARGET).mc -o $(TBTARGET).mif

clean:
	rm -f ./*.s $(TARGET) ./*.bin ./*.mif ./*.mc ./*.header ./*.section ./*.cfg

# dump disassembled code:
# riscv64-unknown-elf-objdump --no-address --no-show-raw-insn -dj .text ./test > instr_full.s