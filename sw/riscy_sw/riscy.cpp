#include "riscy.hpp"

extern void ttt();

int main() {
	printf_("Hello Riscy \r\n");
	sanity_test_seg();
	sanity_test_serial();

	Serial s = Serial();
	volatile char c;

	Seg dbg_seg = Seg();
	uint32_t iter = 1;
	while (1) {
		dbg_seg.set_seg(iter);
		dbg_seg.write_seg();
		c = s.pull_input();
		iter ++;

		dbg_seg.set_seg(iter);
		dbg_seg.write_seg();
		s.putc(c);
		iter ++;
	}

	halt_riscy();
}


void sanity_test_seg() {
	Seg* seg = new Seg();
	seg->set_seg(0xabcdef);
	seg->write_seg();
	delete seg;
}


void sanity_test_serial() {
	const char* hellostr = "0123456789abcdef\r\n";
	Serial* serial = new Serial();
	serial->print(hellostr);
	delete serial;
}


void halt_riscy() {
	__asm__("li a0,42");
	__asm__("li a7,93");
	__asm__("ebreak");
	return;
}
