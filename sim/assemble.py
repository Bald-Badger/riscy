'''
risc-v assembler, convert a .s file into .asm machine code
'''

from riscv_assembler.convert import AssemblyConverter
import shutil
import os

in_name = 'instr.s'
middle_name = 'instr.txt'
out_name = 'instr.asm'

def old_main():
    cnv = AssemblyConverter(output_type='tp', hexMode=True)
    cnv.convert(in_name)
    move_file()
    clean()
    process_file()


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
    append_zeros()


def append_zeros(name=out_name):
    f = open(name, 'a')
    zeros = ['00000000\n'] * 10
    f.writelines(zeros)
    f.close()


def find(name, path):
    for root, dirs, files in os.walk(path):
        if name in files:
            return os.path.join(root, name)


def assemble_default():
    example = "java -jar rars.jar dump 0x00400000-0x00401000 " \
              "HexText instr.asm instr.s"
    addr = "0x00400000-0x00401000"
    cmd = "java -jar rars.jar dump " + addr + " HexText " + out_name + " " + in_name
    os.system(cmd)


def assemble(filename='', out_name=''):
    if filename == '':
        assemble_default()
        return

    if out_name == '':
        out_name = 'instr.asm'

    example = "java -jar rars.jar dump 0x00400000-0x00401000 " \
              "HexText instr.asm instr.s"
    addr = "0x00400000-0x00401000"
    in_name = find(filename, '.\\tests')
    if in_name is None:
        print("file: " + filename + "not found")
        return
    cmd = "java -jar rars.jar dump " + addr + " HexText " + out_name + " " + in_name
    print("assembling file: " + in_name)
    os.system(cmd)
    append_zeros(out_name)


if __name__ == '__main__':
    mylist = os.listdir('.\\tests\\riscv-tests')
    print(mylist)
    compile_list = ['add.s', 'addi.s', 'and.s', 'andi.s', 'div.s', 'divu.s', 'lui.s', 'mul.s', 'mulh.s', 'mulhsu.s', 'mulhu.s', 'or.s', 'ori.s', 'rem.s', 'remu.s', 'simple.s', 'sll.s', 'slli.s', 'slt.s', 'slti.s', 'sltiu.s', 'sltu.s', 'sra.s', 'srai.s', 'srl.s', 'srli.s', 'sub.s', 'xor.s', 'xori.s']
    for f in compile_list:
        assemble(f, f[:-2]+'.asm')

