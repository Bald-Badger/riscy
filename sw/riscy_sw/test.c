#include "test.h"
#include "perf.h"
#include <stdint.h>
#include <stdlib.h>


int main() {
	set_seg_single(1, 0xF);
	halt_riscy();
}

const uint32_t seg_base	= SEG_BASE;

void halt_riscy() {
	__asm__("ecall");
	return;
}

void set_seg_single (int index, int number) {
	uint32_t* seg_va = ((uint32_t*)SEG_BASE + index);
	uint32_t hex_seg_digit = number & SEG_DATA_MASK;
	*(uint32_t*)seg_va = hex_seg_digit;
}
