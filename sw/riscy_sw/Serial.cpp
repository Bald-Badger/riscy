#include "Serial.hpp"

Serial::Serial() {}

Serial::~Serial() {}

volatile uint32_t Serial::tx_char = '\0';
volatile uint32_t Serial::rx_char = '\0';
volatile uint32_t Serial::rx_buf_len = 0;

void Serial::putc(char c){
	uint32_t char_int_32 = ((uint32_t)(c)) & UART_DATA_MASK;
	tx_char = char_int_32;
	*((uint32_t*)UART_DATA_ADDR) = tx_char;
	tx_char = 0;
}


void Serial::write_string(const char* c, int l) {
	int i;
	for (i = 0; i < l; i++){
		putc(c[i]);
	}
	return;
}


uint32_t Serial::read_strlen() {
	rx_buf_len = *((uint32_t*)UART_DLEN_ADDR);
	return rx_buf_len;
}


char Serial::read_char() {
	rx_char = ((char)(*((uint32_t*)UART_DATA_ADDR))) & UART_DATA_MASK;
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
	while (1) {
		available = read_strlen();
		if (available > 0) {
			break;
		}
	}
	char c = read_char() & UART_DATA_MASK;
	return c;
}


int Serial::char2int(char c) {
	switch (c)
	{
		case '0':
			return 0;
		break;

		case '1':
			return 1;
		break;

		case '2':
			return 2;
		break;

		case '3':
			return 3;
		break;

		case '4':
			return 4;
		break;

		case '5':
			return 5;
		break;

		case '6':
			return 6;
		break;

		case '7':
			return 7;
		break;

		case '8':
			return 8;
		break;

		case '9':
			return 9;
		break;

		default:
			return -1;
	}
}
