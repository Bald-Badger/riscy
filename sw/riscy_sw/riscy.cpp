#include "riscy.hpp"
#include "perf.hpp"
#include "Seg.hpp"
#include "Serial.hpp"
#include "printf.h"

int main() {
	printf_("Hello Riscy \r\n");
	sanity_test_seg();
	sanity_test_serial();
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

