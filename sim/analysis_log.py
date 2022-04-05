# analysis_log.py
import csv


def load_files():
	with open('reg_dut.csv', newline='') as csvfile:
		reader = csv.DictReader(csvfile, quotechar='"', skipinitialspace=True)
		reg_dut_arr = list(reader)
	csvfile.close()

	with open('reg_ref.csv', newline='') as csvfile:
		reader = csv.DictReader(csvfile, quotechar='"', skipinitialspace=True)
		reg_ref_arr = list(reader)
	csvfile.close()

	with open('mem_dut.csv', newline='') as csvfile:
		reader = csv.DictReader(csvfile, quotechar='"', skipinitialspace=True)
		mem_dut_arr = list(reader)
	csvfile.close()

	with open('mem_ref.csv', newline='') as csvfile:
		reader = csv.DictReader(csvfile, quotechar='"', skipinitialspace=True)
		mem_ref_arr = list(reader)
	csvfile.close()

	with open('pc_dut.csv', newline='') as csvfile:
		reader = csv.DictReader(csvfile, quotechar='"', skipinitialspace=True)
		pc_dut_arr = list(reader)
	csvfile.close()

	with open('pc_ref.csv', newline='') as csvfile:
		reader = csv.DictReader(csvfile, quotechar='"', skipinitialspace=True)
		pc_ref_arr = list(reader)
	csvfile.close()

	return (mem_dut_arr, mem_ref_arr, reg_dut_arr, reg_ref_arr, pc_dut_arr, pc_ref_arr)


	# format the log dict
def sanitize(log):
	for i in range (len(log)):
		for j in range(len(log[i])):
			if "time" in log[i][j]:
				log[i][j]["time"] = int(log[i][j]["time"])
			if "time " in log[i][j]:
				log[i][j]["time "] = int(log[i][j]["time "])
			if "pc" in log[i][j]:
				log[i][j]["pc"] = int(log[i][j]["pc"], 16)
			if "pc " in log[i][j]:
				log[i][j]["pc "] = int(log[i][j]["pc "], 16)
			if "addr" in log[i][j]:
				log[i][j]["addr"] = hex(int(log[i][j]["addr"], 16))
			if "addr " in log[i][j]:
				log[i][j]["addr "] = hex(int(log[i][j]["addr "], 16))
			if "data" in log[i][j]:
				log[i][j]["data"] = hex(int(log[i][j]["data"], 16))
			if "data " in log[i][j]:
				log[i][j]["data "] = hex(int(log[i][j]["data "], 16))
	return log


def compare_mem_log(mem_dut_arr, mem_ref_arr):
	dut_len = len(mem_dut_arr)
	ref_len = len(mem_ref_arr)
	if dut_len != ref_len:
		print("mem log len mismatch")
	l = min([dut_len, ref_len])
	err = 0
	type = ""
	for i in range(l):
		err = 0
		if (mem_dut_arr[i]["rw"] != mem_ref_arr[i]["rw"]):
			err = 1
			type = "rw"
		if (mem_dut_arr[i]["data"] != mem_ref_arr[i]["data"]):
			err = 1
			type = "data"
		if (mem_dut_arr[i]["addr "] != mem_ref_arr[i]["addr "]):
			err = 1
			type = "addr"
		if err:
			print("mem mismatch found at index {}, type: {}, dut time: {}, ref time: {}, ref pc: {}".format(
				i, type, int(mem_dut_arr[i]["time"]), int(mem_ref_arr[i]["time"]), hex(mem_ref_arr[i]["pc"])
			))
			return
	if err == 0:
		if dut_len == ref_len:
			print("mem flow good")
		else:
			print("mem flow good but len mismatch")


def compare_reg_log(reg_dut_arr, reg_ref_arr):
	dut_len = len(reg_dut_arr)
	ref_len = len(reg_ref_arr)
	if dut_len != ref_len:
		print("reg log len mismatch")
	l = min([dut_len, ref_len])
	err = 0
	for i in range(l):
		err = 0
		type = ""
		if (reg_dut_arr[i]["rw"] != reg_ref_arr[i]["rw"]):
			err = 1
			type = "rw"
		if (reg_dut_arr[i]["data"] != reg_ref_arr[i]["data"]):
			err = 1
			type = "data"
		if (reg_dut_arr[i]["addr "] != reg_ref_arr[i]["addr "]):
			err = 1
			type = "addr"
		if err:
			print("reg mismatch found at index {}, type: {}, dut time: {}, ref time: {}, ref pc: {}".format(
				i, type, int(reg_dut_arr[i]["time"]), int(reg_ref_arr[i]["time"]), hex(reg_ref_arr[i]["pc"])
			))
			return
	if err == 0:
		if dut_len == ref_len:
			print("reg flow good")
		else:
			print("reg flow good but len mismatch")


def compare_pc_log(pc_dut_arr, pc_ref_arr):
	dut_len = len(pc_dut_arr)
	ref_len = len(pc_ref_arr) - 1 # ref module will exe one more instr after halt
	if dut_len != ref_len:
		print("pc log len mismatch")
	l = min([dut_len, ref_len])
	err = 0
	for i in range(l):
		err = 0
		if (pc_dut_arr[i]["pc "] != pc_ref_arr[i]["pc "]):
			err = 1
		if err:
			print("pc mismatch found at index {}, dut time: {}".format(i, pc_dut_arr[i]["time"]))
			return
	if err == 0:
		if dut_len == ref_len:
			print("pc flow good")
		else:
			print("pc flow good but len mismatch")


def main():
	log = (mem_dut_arr, mem_ref_arr, reg_dut_arr, reg_ref_arr, pc_dut_arr, pc_ref_arr) = load_files()
	for i in range (len(log)):
		print(log[i][0])
	log = sanitize(log)
	for i in range (len(log)):
		print(log[i][0])
	compare_mem_log(mem_dut_arr, mem_ref_arr)
	compare_reg_log(reg_dut_arr, reg_ref_arr)
	compare_pc_log(pc_dut_arr, pc_ref_arr)


if __name__ == "__main__":
	main()
