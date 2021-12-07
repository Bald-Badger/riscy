def trim(filename='instr_full.s'):
    with open(filename) as file:
        lines = file.readlines()
    for i in range(len(lines)):
        lines[i] = lines[i].replace("<", "")
        lines[i] = lines[i].replace(">", "")
    fp = open('instr_trim.s', 'w')
    fp.writelines(lines)
    fp.close()
    file.close()


if __name__ == '__main__':
    trim()
