verilator --lint-only <>.sv
qsys-edit soc_system.qsys
make quartus
	check for warning!

embedded_command_shell.sh
make rbf && make dtb

git add . && git commit -a
git push

copy files:
mount /dev/mmcblk0p1 /mnt

rm -f /mnt/soc_system.rbf && rm -f /mnt/soc_system.dtb && sync

scp sz3034@micro23.ee.columbia.edu:~/riscy/par/de1/output_files/soc_system.rbf /mnt && sync

scp sz3034@micro23.ee.columbia.edu:~/riscy/par/de1/soc_system.dtb /mnt && sync

reboot -h now

check:
ls "/proc/device-tree/sopc@0/bridge@0xc0000000/"
cat "/proc/device-tree/sopc@0/bridge@0xc0000000/vga@0x100000000/compatible"

run user:
cd ~/lab3/lab3-sw
git pull
make
rmmod vga_ball
insmod vga_ball.ko
lsmod
./hello

make && rmmod vga_ball && insmod vga_ball.ko && ./hello

cd ~/lab3/lab3-sw && git pull && make && rmmod vga_ball && insmod vga_ball.ko && ./hello
