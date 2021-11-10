import os
import shutil
import time

if __name__ == '__main__':
    f = open('result.txt', 'w')
    f.close()
    test_list = os.listdir('./tests/mif')
    transcript = "./transcript.txt"
    visiable = False
    if visiable:
        cmd = "vsim -c -do ./run_all.do"
    else:
        cmd = "vsim -c -do ./run_all.do > NUL"
    for test in test_list:
        src = "./tests/mif/" + test
        dest = "./instr.mif"
        shutil.copyfile(src, dest)
        os.system(cmd)
        f = open("./result.txt", 'r')
        result = f.readline()
        f.close()
        print("test: " + test + " " + result)
        time.sleep(0.5)
        try:
            os.remove(transcript)
            os.remove("./result.txt")
        except FileNotFoundError:
            pass
        except PermissionError:
            pass

