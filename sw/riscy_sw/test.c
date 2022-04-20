#include "test.h"
#include "perf.h"
#include <stdint.h>
#include <stdlib.h>


int main() {
	char hellostr[20] = "0123456789abcdef\r\n";
	uart_write_string(hellostr, 20);
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
	__asm__("li a0, 42");
	__asm__("li a7, 93");
	__asm__("ecall");
	return;
}

void set_seg_single (int index, int number) {
	uint32_t* seg_pa = (uint32_t*)((void*)SEG_BASE + index * 4);
	uint32_t hex_seg_digit = number;
	*(uint32_t*)seg_pa = hex_seg_digit;
}

void uart_write_string (char* c, int strlen) {
	int i = 0;
	for (i = 0; i < strlen; i++){
		uint32_t char_int_32 = ((uint32_t)c[i]) & UART_DATA_MASK;
		*((uint32_t*)UART_DATA_ADDR) = char_int_32;
	}
}

int uart_read_strlen () {
	return *((uint32_t*)UART_DLEN_ADDR);
}

char uart_read_char () {
	return (char)(*((uint32_t*)UART_DATA_ADDR) >> 24);
}
