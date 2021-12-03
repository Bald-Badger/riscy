GCC = riscv64-unknown-elf-gcc
CFLAGS = -Wall -O0 -mdiv -mno-fdiv -no-pie -mstrict-align -mlittle-endian -march=rv32im -mabi=ilp32 -lstdc++ -mbranch-cost=2 -mexplicit-relocs
# -wall: optimization for compilation time
# -O0: only optimization for compilation time
# -mdiv: use hardware int division
# -mno-fdiv: do not use hardware fp div
# -no-pie: don't make position independent executable (PIE)
# -mstrict-align: Do not generate unaligned memory accesses
# -mlittle-endian: generate little endian code
# -march=rv32im: rv32im ISA
# -mabi=ilp32: 32 bit data without fp
# -lstdc++: enable c++ compile
# -mbranch-cost=2: low branch cost, so hopefully disable instruction reorder
# -mexplicit-relocs: use assembler relocation operators when dealing with symbolic addresses, hopefully reduce pseudo instruction

OBJCOPY = riscv64-unknown-elf-objcopy
COPYFLAGS = -O binary --only-section=.text
TARGET = test
TBTARGET = instr
SRC = $(TARGET).c
SDEST = $(TARGET).s
JAVA = java
RARSADDR = 0x00000000-0x00008000
JAVAFLAGS = -jar rars.jar a mc CompactTextAtZero dump $(RARSADDR) HexText
PYTHON = python
PYTHONFPAGS = ./mc2mif.py

all: clean asm elf bin mif

asm:
	$(GCC) $(CFLAGS) -S $(SRC) -o $(SDEST)
	
elf:
	$(GCC) $(CFLAGS) -c $(SRC) -o $(TARGET)

bin:
	$(OBJCOPY) $(COPYFLAGS) $(TARGET) $(TBTARGET).bin

mif:
	python ./bin2mif.py $(TBTARGET).bin instr.mif 32

rars_mc: clean asm 
	$(JAVA) $(JAVAFLAGS) $(TARGET).mc $(TARGET).s

rars: rars_mc
	$(PYTHON) $(PYTHONFPAGS) -i $(TARGET).mc -o my_test_$(TARGET).mif

clean:
	rm -f *.s $(TARGET) *.bin *.mif *.mc
