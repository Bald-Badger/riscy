import os
import shutil


if __name__ == '__main__':
    test_list = os.listdir('./tests/mif')
    transcript = "./transcript.txt"
    visiable = False
    if visiable:
        cmd = "vsim -c -do ./run_all.do"
    else:
        cmd = "vsim -c -do ./run_all.do > ./transcript.txt"
    for test in test_list:
        src = "./tests/mif/" + test
        dest = "./instr.mif"
        shutil.copyfile(src, dest)
        os.system(cmd)
        f = open("./result.txt", 'r')
        result = f.readline()
        f.close()
        print("test: " + test + " " + result)
        try:
            os.remove(transcript)
        except FileNotFoundError:
            pass

