#ifndef _SERIAL_HPP_
#define _SERIAL_HPP_

	#include <stdint.h>
	#include <string.h>
	#include "perf.hpp"

	class Serial {

		private:
			static constexpr char linefeedstr[] = "\r\n";
			static void write_string(const char*, int);

		public:
			Serial();
			~Serial();
			static void print(const char*);
			static void println(const char*);
			int read_strlen();
			char read_char();
	};

#endif
