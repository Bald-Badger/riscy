#include "riscy.hpp"
#include "ttt.hpp"

int main() asm ("main");

int main() {
	_riscy_start();

	printf_("Hello Riscy \r\n");

	sanity_test_seg();
	sanity_test_serial();

	Seg* dbg_seg = new Seg;

	// ttt();


	Serial* s = new Serial;
	int buflen = 0;
	char c;
	for(;;) {
		buflen = s->read_strlen();
		if (buflen > 0) {
			c = s->read_char();
			s->putc(c);
		}
	}


	halt_riscy();
}


void _riscy_start() {
	//init sp
	__asm__("li sp, 0x03fffffc");
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

