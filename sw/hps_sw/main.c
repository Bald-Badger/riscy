#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "include/hps.h"

// global define
const uint32_t h2f_lw_base = (unsigned int) ALT_LWFPGASLVS_OFST;
const uint32_t h2f_base = (unsigned int) 0xC0000000;

// sdram define
const uint32_t sdram_range		= 0x03FFFFFF;	// 0x0 - 0x3ffffff
const uint32_t offset_sdram		= 0x00000000;	// offset from bridge
const uint32_t sdram_size_byte	= 0x04000000;	// 512Mb
const uint32_t sdram_size_word	= 0x01000000;	// 64MB


// 7-seg display define
const uint32_t seg_range		= 0x0000001F;	// 0x0 - 0x1f
const uint32_t offset_seg		= 0x04000000;	// offset from bridge
const uint32_t seg_size_byte	= 0x00000020;	// 32 bytes
const uint32_t seg_size_word	= 0x00000008;	// 8 words (6 needed)
const uint32_t seg_addr_mask	= 0xFFFFFFFC;	// word-align
const uint32_t seg_data_mask	= 0x0000000F;	// only first byte valid


void* map_addr (int pa_base, int size_byte) {
	uint32_t page_mask, page_size;
	int fd;
	void* return_va;
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( (void*)(-1) );
	}

	// get page size in byte
	page_size = sysconf(_SC_PAGESIZE);
	
	// in number of allocated page
	uint32_t alloc_mem_size = (((size_byte / page_size) + 1) * page_size);
	page_mask = (page_size - 1);
	return_va = mmap( 
		NULL, 
		alloc_mem_size, 
		( PROT_READ | PROT_WRITE ), 
		MAP_SHARED, 
		fd, 
		(pa_base & ~page_mask)
	);
	
	if( return_va == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( (void*)(-1) );
	}
	close( fd );
	return (return_va);
}

int unmap_addr (void* vp_base, u_int32_t unmap_size_byte) {
	if( munmap( vp_base, unmap_size_byte ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		return( -1 );
	}
	return (0);
}


// SDRAM controlling functions

void* init_sdram() {
	uint32_t sdram_pa_base	= h2f_base + offset_sdram;	// PA of sdram from HPS's perspective
	return map_addr (sdram_pa_base, sdram_size_byte);
}

int clean_sdram (void* vp_base) {
	return unmap_addr (vp_base, sdram_size_byte);
}

uint32_t read_sdram (uint32_t * addr) {
	return *((uint32_t *)addr);
}

void write_sdram (uint32_t* addr, uint32_t data) {
	*addr = data;
}

// off in word, not byte
int touch_sdram (void* base, uint32_t off) {
	uint32_t data = rand();
	write_sdram(((uint32_t *)base) + off, data);
	uint32_t x = read_sdram(((uint32_t *)base) + off);
	uint32_t sdram_pa_base	= h2f_base + offset_sdram;	// PA of sdram from HPS's perspective
	if (x == data) {
		printf("touche word off: %x, PA: %x success \n", off, (sdram_pa_base) + (off * 4));
		return 0;
	} else {
		printf("touche PA %x fail \n", (sdram_pa_base) + (off * 4));
		return -1;
	}
}

void touch_sdram_range (void* base, int start, int step) {
	int i;
	for (i = 0; i > -1; i += step) {
		touch_sdram(base, start + (step * i));
	}
}


// 7-Seg controlling functions

void* init_seg() {
	uint32_t seg_pa_base = h2f_base + offset_seg;	// PA of sdram from HPS's perspective
	return map_addr (seg_pa_base, seg_size_byte);
}

int clean_seg (void* vp_base) {
	return unmap_addr (vp_base, seg_size_byte);
}

void set_seg_single (void* vp, int index, uint32_t number) {
	vp = (void*)((uint32_t)vp & seg_addr_mask);
	uint32_t hex_seg_digit = number & seg_data_mask;
	vp = (void*)((uint32_t)vp + (index << 2));
	*(uint32_t*)vp = hex_seg_digit;
}

void set_seg (void* vp, uint32_t number) {
	int i;
	for (i = 0; i < 6; i++) {
		set_seg_single (vp, i, number);
		number = number >> 4;
	}
	return;
}

void dump_binary () {

}


void smoke_test () {
	void* sdram_vp = init_sdram();
	touch_sdram(sdram_vp, 0xffffff);
	clean_sdram(sdram_vp);

	void* seg_vp = (void*)(init_seg());
	set_seg (seg_vp, 0x00123456);
	clean_seg(seg_vp);
}


int main () {
	uint32_t instr_arr[1000];
	FILE* ptr;
	ptr = fopen("instr.bin","rb");
	fread(instr_arr, sizeof(instr_arr), 1, ptr);
	int i;
	for (i = 0; i < 10; i++) {
		printf("%x\n", instr_arr[i]);
	}
}
