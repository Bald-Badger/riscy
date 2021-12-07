import re


def trim(filename='dasm.s'):
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
    fp = open('instr.s', 'w')
    for line in lines:
        regex = "0x\w+\n"
        if len(re.findall(regex, line)) > 0:
            line = re.sub(regex, str(int(re.findall(regex, line)[0], 0))+'\n', line)
            fp.write(line)
            #print(line)
        else:
            fp.write(line)
            #print(line)
    file.close()
    fp.close()


if __name__ == '__main__':
    trim()
