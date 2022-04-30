#include "Serial.hpp"

Serial::Serial() {}

Serial::~Serial() {}

volatile uint32_t Serial::tx_char = '\0';
volatile uint32_t Serial::rx_char = '\0';
volatile int Serial::rx_buf_len = 0;

void Serial::putc(char c){
	uint32_t char_int_32 = (uint32_t)(c) & UART_DATA_MASK;
	tx_char = char_int_32;
	*((uint32_t*)UART_DATA_ADDR) = tx_char;
	tx_char = '\0';
}


void Serial::write_string(const char* c, int l) {
	int i;
	for (i = 0; i < l; i++){
		putc(c[i]);
	}
	return;
}


int Serial::read_strlen() {
	rx_buf_len = *((uint32_t*)UART_DLEN_ADDR);
	return rx_buf_len;
}


char Serial::read_char() {
	rx_char = (char)(*((uint32_t*)UART_DATA_ADDR));
	return rx_char;
}


void Serial::print(const char* str) {
	int l = 0;
	while (str[l] != '\0') {
		l++;
	}
	write_string(str, l);
	return;
}


void Serial::println(const char* str) {
	print(str);
	print(linefeedstr);
	return;
}

char Serial::pull_input() {
	int available = 0;
	while (available == 0) {
		available = read_strlen();
	}
	return read_char();
}
