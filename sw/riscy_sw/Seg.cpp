#include "Seg.hpp"

Seg::Seg() {
	for (int i = 0; i < 6; i++) {
		this->digit[i] = i;
	}
}

Seg::~Seg() {}

void Seg::set_seg_single (int index, int number) {
	uint32_t* seg_pa = &((uint32_t*)SEG_BASE)[index];
	uint32_t hex_seg_digit = number;
	*(uint32_t*)seg_pa = hex_seg_digit;
}

void Seg::set_seg_digit (int index, int value) {
	this->digit[index] = value & SEG_DATA_MASK;
}

void Seg::set_seg(int value) {
	for (int i = 0; i < 6; i++) {
		this->digit[i] = value & SEG_DATA_MASK;
		value >>= 4;
	}
}

void Seg::write_seg() {
	for (int i = 0; i < 6; i++) {
		set_seg_single(i, digit[i]);
	}
}

