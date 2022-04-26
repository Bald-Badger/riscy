def get_entry_addr(filename="./test.header"):
	with open(filename) as file:
		lines = file.readlines()
		lines = [line.rstrip() for line in lines]
	del lines[0]
	for i in range(len(lines)):
		lines[i] = " ".join(lines[i].split())  # remove dupe white space
	header_dict = {}
	for line in lines:
		temp_line = line.split(":")
		header_dict[temp_line[0]] = temp_line[1]
	entry_addr = int(header_dict["Entry point address"], 16)
	elf_va_offset = 0x10000
	print("entry point is base : 0x10000, offset: ",(entry_addr - elf_va_offset))
	print("binary offset: {0:b}".format(entry_addr - elf_va_offset))
	fp = open("boot.cfg", 'w')
	fp.write(format(entry_addr - elf_va_offset, "x"))
	fp.close()
	return entry_addr


def get_text_addr(filename="./test.section"):
	with open(filename) as file:
		lines = file.readlines()
		lines = [line.rstrip() for line in lines]
	textline = ''
	for line in lines:
		if ".text" in line:
			textline = " ".join(line.split())  # remove dupe white space
	file.close()
	textline = textline.split()
	index = -1
	for i in range(textline.__len__()):
		if textline[i] == '.text':
			index = i
		if index >= 0 and i == index + 2:
			return int(textline[i], 16)


def get_main_addr(filename="./instr_full.s"):
	with open(filename) as file:
		lines = file.readlines()
		lines = [line.rstrip() for line in lines]
	for i in range(len(lines)):
		lines[i] = " ".join(lines[i].split())  # remove dupe white space
	for i in range(len(lines)):
		if '''<main>:''' in lines[i]:
			asm = lines[i].split()
			return int(asm[0], 16)
	print("get main addr failed")
	return -1


def get_enrty_point_offset():
	entry_addr = get_entry_addr()
	print(f"entry addr: {entry_addr}")
	text_addr = get_text_addr()
	print(f"text addr: {text_addr}")
	boot_offset = entry_addr - text_addr
	print(f"boot offset: {boot_offset} words")
	fp = open("boot.cfg", 'w')
	fp.write(format(boot_offset, "x"))
	fp.close()


# offset fron text base
def get_main_offset_old():
	main_addr = get_main_addr()
	print(f"main_addr: {main_addr}")
	text_addr = get_text_addr()
	print(f"text addr: {text_addr}")
	boot_offset = main_addr - text_addr
	print(f"boot offset: {int(boot_offset/4)} words")
	print("boot_offset: {0:b} byte".format(boot_offset))
	fp = open("boot.cfg", 'w')
	fp.write(format(boot_offset, "x"))
	fp.close()


# offset from start of ELF file in
def get_main_offset():
	base_addr = 0x10000
	print(f"base addr: 0x{hex(base_addr)}")

	main_addr = get_main_addr()
	print(f"main_addr: 0x{hex(main_addr)}")

	entry_addr = get_entry_addr()
	print(f"entry addr: {hex(entry_addr)}")
	
	entry_offset = entry_addr - base_addr
	print("entry_offset: {0:b}".format(entry_offset >> 2))

	boot_offset = main_addr - base_addr

	print(f"boot offset: {int(boot_offset >> 2)} words")
	print("boot_offset: {0:b} words".format(boot_offset >> 2))

	fp = open("boot.cfg", 'w')
	fp.write(format(boot_offset >> 2, "x"))
	fp.close()



if __name__ == '__main__':
	get_main_offset()
