import argparse

if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='mc to mif parser')
	parser.add_argument('-i','--in', help='input mc file name', required=True)
	parser.add_argument('-o','--out', help='output mif file name', required=True)
	args = vars(parser.parse_args())

	fix =   "DEPTH = 1024;                   -- The size of memory in words\n" \
			"WIDTH = 32;                    -- The size of data in bits\n" \
			"ADDRESS_RADIX = HEX;          -- The radix for address values\n" \
			"DATA_RADIX = HEX;             -- The radix for data values\n" \
			"CONTENT                       -- start of (address : data pairs)\n" \
			"BEGIN \n\n"
	out_name = args['out']
	mc_file = args['in']
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
