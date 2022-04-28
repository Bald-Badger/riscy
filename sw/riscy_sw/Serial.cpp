#include "Serial.hpp"


Serial::Serial() {}


Serial::~Serial() {}


void Serial::write_string(const char* c, int l) {
	int i;
	for (i = 0; i < l; i++){
		uint32_t char_int_32 = ((uint32_t)c[i]) & UART_DATA_MASK;
		*((uint32_t*)UART_DATA_ADDR) = char_int_32;
	}
	return;
}


int Serial::read_strlen() {
	return *((uint32_t*)UART_DLEN_ADDR);
}


char Serial::read_char() {
	return (char)(*((uint32_t*)UART_DATA_ADDR));
}


void Serial::print(const char* str) {
	// int l = strlen(str);
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
