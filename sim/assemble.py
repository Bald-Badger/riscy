'''
risc-v assembler, convert a .s file into .asm machine code
'''

from riscv_assembler.convert import AssemblyConverter
import shutil

in_name = 'instr.s'
middle_name = 'instr.txt'
out_name = 'instr.asm'


def clean():
    shutil.rmtree('./instr')


def move_file():
    old_path = './instr/txt/' + middle_name
    new_path = './' + out_name
    try:
        shutil.move(old_path, new_path)
    except FileNotFoundError:
        print('file not found, skipped file copy')


# get rid of all '0x'
def process_file():
    f = open(out_name, 'r')
    lines = f.readlines()
    f.close()
    for i in range(len(lines)):
        lines[i] = lines[i][2:]
    f = open(out_name, 'w')
    f.writelines(lines)
    f.close()


if __name__ == '__main__':
    cnv = AssemblyConverter(output_type='tp', hexMode=True)
    cnv.convert(in_name)
    move_file()
    clean()
    process_file()


