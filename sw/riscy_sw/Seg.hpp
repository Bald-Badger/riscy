#ifndef _SEG_HPP_
#define _SEG_HPP_

	#include <stdint.h>
	#include "perf.hpp"

	class Seg {

		private:
			uint32_t digit[6];
			void set_seg_single (int, int);

		public:
			Seg();
			~Seg();
			void set_seg_digit(int, int);
			void set_seg(int);
			void write_seg();

	};

#endif
