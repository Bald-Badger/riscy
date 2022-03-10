import os
import shutil
import time

if __name__ == '__main__':
    f = open('result.txt', 'w')
    f.close()
    test_list = os.listdir('./tests/mc')
    visiable = False
    if visiable:
        cmd = "vsim -c -do ./run_all.do"
    else:
        cmd = "vsim -c -do ./run_all.do > NUL"
    for test in test_list:
        src = "./tests/mc/" + test
        dest = "./instr.mc"
        shutil.copyfile(src, dest)
        os.system(cmd)
        f = open("./result.txt", 'r')
        result = f.readline()
        f.close()
        print("test: " + test + " " + result)
        time.sleep(0.1)
