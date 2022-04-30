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
			static volatile int rx_buf_len;

		public:
			Serial();
			~Serial();
			static void putc(char);
			static void print(const char*);
			static void println(const char*);
			int read_strlen();
			char read_char();
			char pull_input();
	};

#endif
