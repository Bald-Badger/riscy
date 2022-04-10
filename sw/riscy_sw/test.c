#include "test.h"
#include "perf.h"
#include <stdint.h>
#include <stdlib.h>


int main() {
	set_seg_single(0, 0xf);
	set_seg_single(1, 0xe);
	set_seg_single(2, 0xd);
	set_seg_single(3, 0xc);
	set_seg_single(4, 0xb);
	set_seg_single(5, 0xa);
	halt_riscy();
}

const uint32_t seg_base	= SEG_BASE;

void halt_riscy() {
	__asm__("ecall");
	return;
}

void set_seg_single (int index, int number) {
	uint32_t* seg_pa = ((uint32_t*)SEG_BASE + index);
	uint32_t hex_seg_digit = number;
	*(uint32_t*)seg_pa = hex_seg_digit;
}
