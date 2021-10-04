import os
import shutil


if __name__ == '__main__':
    test_list = os.listdir('./tests/asm')
    transcript = "./transcript.txt"
    cmd = "vsim -c -do ./run_all.do > ./transcript.txt"
    # cmd = "vsim -c -do ./run_all.do"
    for test in test_list:
        src = "./tests/asm/" + test
        dest = "./instr.asm"
        shutil.copyfile(src, dest)
        os.system(cmd)
        f = open("./result.txt")
        result = f.readline()
        f.close()
        print("test: " + test + " " + result)
        try:
            os.remove(transcript)
        except FileNotFoundError:
            pass

