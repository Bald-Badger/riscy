GCC = riscv64-unknown-elf-gcc
CFLAGS = -Wall -O0 -mdiv -no-pie -mstrict-align -mlittle-endian -march=rv32im -mabi=ilp32 -lstdc++
OBJCOPY = riscv64-unknown-elf-objcopy
COPYFLAGS = -O binary --only-section=.text
TARGET = test
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
	$(OBJCOPY) $(COPYFLAGS) $(TARGET) $(TARGET).bin

mif:
	python ./bin2mif.py $(TARGET).bin instr.mif 32

rars_mc: clean asm 
	$(JAVA) $(JAVAFLAGS) $(TARGET).mc $(TARGET).s

rars: rars_mc
	$(PYTHON) $(PYTHONFPAGS) -i $(TARGET).mc -o my_test_$(TARGET).mif

clean:
	rm -f *.s $(TARGET) *.bin *.mif
