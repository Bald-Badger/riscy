import os
import time
from riscv_assembler.convert import AssemblyConverter

if __name__ == '__main__':
	cnv = AssemblyConverter(output_type="p")  # just printing
	cnv.convert("instr.s")
