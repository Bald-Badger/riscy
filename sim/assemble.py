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
        out_name = 'instr.mc'

    example = "java -jar rars.jar mc CompactTextAtZero dump 0x00002000-0x00002fff " \
              "HexText instr.asm instr.s"
    addr = "0x00000000-0x00004000"
    in_name = find(filename, '.\\tests')
    if in_name is None:
        print("file: " + filename + "not found")
        return
    cmd = "java -jar rars.jar mc CompactTextAtZero dump " + addr + " HexText " + out_name + " " + in_name
    print("assembling file: " + in_name)
    os.system(cmd)
    append_zeros(out_name)
    try:
        shutil.move('./'+out_name, './tests/mc/'+out_name[:-3]+'.mc')
    except FileNotFoundError:
        print('file not found, skipped file copy')


def compile_smoke_test():
    mylist = os.listdir('.\\tests\\riscv-tests')
    print(mylist)
    smoke_list = ['add.s', 'addi.s', 'and.s', 'andi.s', 'div.s', 'divu.s', 'lui.s', 'mul.s', 'mulh.s', 'mulhsu.s', 'mulhu.s', 'or.s', 'ori.s', 'rem.s', 'remu.s', 'simple.s', 'sll.s', 'slli.s', 'slt.s', 'slti.s', 'sltiu.s', 'sltu.s', 'sra.s', 'srai.s', 'srl.s', 'srli.s', 'sub.s', 'xor.s', 'xori.s']
    smoke_list.append('jalr.s')
    smoke_list.append('loop.s')
    smoke_list.append('memory.s')
    smoke_list.append('my_test_ldst.s')
    smoke_list.append('my_test_simple.s')
    smoke_list.append('my_test_div.s')

    for f in smoke_list:
        assemble(f, f[:-2]+'.mc')


# example .mif format
'''
DEPTH = 32;                   -- The size of memory in words
WIDTH = 8;                    -- The size of data in bits
ADDRESS_RADIX = HEX;          -- The radix for address values
DATA_RADIX = BIN;             -- The radix for data values
CONTENT                       -- start of (address : data pairs)
BEGIN

00 : 00000000;                -- memory address : data
01 : 00000001;
02 : 00000010;
03 : 00000011;
04 : 00000100;
05 : 00000101;
06 : 00000110;
07 : 00000111;
08 : 00001000;
09 : 00001001;
0A : 00001010;
0B : 00001011;
0C : 00001100;

END;
'''
def mc_to_mif(mc_file, out_name):
    fix =   "DEPTH = 1024;                   -- The size of memory in words\n" \
            "WIDTH = 32;                    -- The size of data in bits\n" \
            "ADDRESS_RADIX = HEX;          -- The radix for address values\n" \
            "DATA_RADIX = HEX;             -- The radix for data values\n" \
            "CONTENT                       -- start of (address : data pairs)\n" \
            "BEGIN \n\n"
    f = open(out_name, 'w')
    f.write(fix)
    mc = open(mc_file, 'r')
    instr = mc.readlines()
    for i in range(instr.__len__()):
        index = hex(i)[2:]
        f.write(index+' : ')
        f.write(instr[i][:-1])
        f.write(';\n')
    f.write("\nEND;\n")
    f.close()


def mc_to_mif_all():
    mylist = os.listdir('./tests/mc')
    for files in mylist:
        mc_file = './tests/mc/' + files
        out_name = './tests/mif/' + files[0:-3] + '.mif'
        mc_to_mif(mc_file, out_name)


def compile_all():
    print("cimpiling .s files")
    compile_smoke_test()
    print("complie finished, converting to mif...")
    mc_to_mif_all()
    print("converting to mif finish")


if __name__ == '__main__':
    compile_all()
