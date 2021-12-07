import re


def trim(filename='instr.s'):
    with open(filename) as file:
        lines = file.readlines()
    for i in range(len(lines)):
        lines[i] = " ".join(lines[i].split())  # remove dupe white space
    fp = open('instr_trim.s', 'w')
    for i in range(len(lines)):
        line = lines[i].split()
        if len(line) == 3:
            fp.write(line[2])
            fp.write('\n')
        elif len(line) == 4:
            fp.write(line[2])
            fp.write('\t')
            fp.write(line[3])
            fp.write('\n')
        else:
            print("error in assemble_trim")
    fp.close()
    file.close()
    with open('instr_trim.s') as file:
        lines = file.readlines()
    for line in lines:
       print(re.findall("0x\d+\n", line))



if __name__ == '__main__':
    trim()
