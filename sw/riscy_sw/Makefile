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
# -mno-relax: no linker relaxations, make less use of GP which i have no idea how to handle
# -D: defines a macro to be used by the preprocessor
# -nostdlib: don't use standard libiary
# --entry main: use main function as entry point
# -fno-builtin-function: ???

GCC = riscv64-unknown-elf-g++
CFLAGS = \
	-Wall \
	-g \
	-O0 \
	-static \
	-mno-fdiv \
	-mstrict-align \
	-mlittle-endian \
	-march=rv32i \
	-mabi=ilp32 \

CFLAGS += -fno-builtin-function

OBJCOPY = riscv64-unknown-elf-objcopy
OBJDUMP = riscv64-unknown-elf-objdump
READELF = riscv64-unknown-elf-readelf
TARGET = ./riscy
PYTHON = python

all: clean assemble deassemble link asm header section offset

assemble: Seg.o Serial.o main.o riscy_startup.o printf.o

Seg.o:Seg.cpp
	$(GCC) $^ -c $(CFLAGS) -o $@

Serial.o:Serial.cpp
	$(GCC) $^ -c $(CFLAGS) -o $@

main.o:riscy.cpp
	$(GCC) $^ -c $(CFLAGS) -o $@

riscy_startup.o:riscy_startup.cpp
	$(GCC) $^ -c $(CFLAGS) -o $@

printf.o:printf.c
	$(GCC) $^ -c $(CFLAGS) -o $@


deassemble: riscy_startup.s Seg.s Serial.s main.s printf.s

Seg.s:Seg.o
	$(OBJDUMP) -D -g $^ > $@

Serial.s:Serial.o
	$(OBJDUMP) -D -g $^ > $@

main.s:main.o
	$(OBJDUMP) -D -g $^ > $@

riscy_startup.s:riscy_startup.o
	$(OBJDUMP) -D -g $^ > $@

printf.s:printf.o
	$(OBJDUMP) -D -g $^ > $@

link:assemble
	$(GCC) --specs=nano.specs -T elf32lriscv.ld -e _riscy_start $(CFLAGS) \
	riscy_startup.o Seg.o Serial.o main.o printf.o \
	-o $(TARGET).elf

asm:link
	$(OBJDUMP) -D riscy.elf > $(TARGET).s

# extract elf header info from elf file
header:link
	$(READELF) -h $(TARGET).elf > $(TARGET).header

# extract section information from elf file
section:link
	$(READELF) -S $(TARGET).elf > $(TARGET).section

offset:asm header section
	$(PYTHON) ./get_off.py

# delete all but .c, .h file
clean:
	rm -f ./*.o ./*.s $(TARGET) \
	./*.bin ./*.mif ./*.mc ./*.header \
	./*.section ./*.cfg ./*.out ./*.elf