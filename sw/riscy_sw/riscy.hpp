#ifndef _RISCY_HPP_
#define _RISCY_HPP_

	#include "perf.hpp"
	#include "Seg.hpp"
	#include "Serial.hpp"
	#include "printf.h"
	
	void _riscy_start() asm ("_riscy_start");
	void halt_riscy();
	void sanity_test_seg();
	void sanity_test_serial();
#endif
