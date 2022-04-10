#include "test.h"
#include "perf.h"
#include <stdint.h>
#include <stdlib.h>


int main() {
	set_seg_single(0, 0x1);
	set_seg_single(1, 0x2);
	set_seg_single(2, 0x3);
	set_seg_single(3, 0x4);
	set_seg_single(4, 0x5);
	set_seg_single(5, 0x6);
	halt_riscy();
}

const uint32_t seg_base	= SEG_BASE;

void halt_riscy() {
	__asm__("ecall");
	return;
}

void set_seg_single (int index, int number) {
	uint32_t* seg_pa = (uint32_t*)((void*)SEG_BASE + index * 4);
	uint32_t hex_seg_digit = number;
	*(uint32_t*)seg_pa = hex_seg_digit;
}
