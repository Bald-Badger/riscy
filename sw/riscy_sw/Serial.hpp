#ifndef _SERIAL_HPP_
#define _SERIAL_HPP_

	#include <stdint.h>
	#include "perf.hpp"

	class Serial {

		private:
			static constexpr char linefeedstr[] = "\r\n";
			static void write_string(const char*, int);
			static volatile uint32_t tx_char;
			static volatile uint32_t rx_char;
			static volatile uint32_t rx_buf_len;

		public:
			Serial();
			~Serial();
			static void putc(char);
			static void print(const char*);
			static void println(const char*);
			static uint32_t read_strlen();
			static char read_char();
			static char pull_input();
	};

#endif
