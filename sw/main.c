#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "include/hps.h"

void *virtual_base_sdram;
int fd_sdram;


// global define
const uint32_t h2f_lw_base = (unsigned int) ALT_LWFPGASLVS_OFST;
const uint32_t h2f_base = (unsigned int) 0xC0000000;

// sdram define
const uint32_t sdram_range		= 0x03ffffff;	// 0x0 - 0x3ffffff
const uint32_t offset_sdram		= 0x00000000;	// offset from bridge
const uint32_t sdram_size_byte	= 0x04000000;	// 512Mb
const uint32_t sdram_size_word	= 0x01000000;	// 64MB
uint32_t	sdram_pa_base;	// PA of sdram from HPS's perspective
void*		virtual_base_sdram;	// VA of sdram from user's perspective
uint32_t	alloc_mem_size_sdram;// page-aligned sdram memory size 


// 7-seg display define
const uint32_t seg_range		= 0x0000001f;	// 0x0 - 0x1f
const uint32_t offset_seg		= 0x04000000;	// offset from bridge
const uint32_t seg_size_byte	= 0x00000020;	// 32 bytes
const uint32_t seg_size_word	= 0x00000008;	// 8 words (6 needed)
uint32_t	seg_pa_base;	// PA of seg from HPS's perspective
void*		virtual_base_seg;	// VA of seg from user's perspective
uint32_t	alloc_mem_size_seg;// page-aligned seg memory size 


int init_sdram() {
	uint32_t page_mask, page_size;
	sdram_pa_base = h2f_base + offset_sdram;

	if( ( fd_sdram = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( -1 );
	}

	page_size = sysconf(_SC_PAGESIZE);
	alloc_mem_size_sdram = (((sdram_size_byte / page_size) + 1) * page_size);
	page_mask = (page_size - 1);
	virtual_base_sdram = mmap( NULL, alloc_mem_size_sdram, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd_sdram, (sdram_pa_base & ~page_mask) );
	
	if( virtual_base_sdram == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd_sdram );
		return( -1 );
	}
	
	return (0);
}

int clean_sdram () {
	if( munmap( virtual_base_sdram, alloc_mem_size_sdram ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd_sdram );
		return( -1 );
	}
	close( fd_sdram );
	return (0);
}

uint32_t read_sdram (uint32_t * addr) {
	return *((uint32_t *)addr);
}

void write_sdram (uint32_t* addr, uint32_t data) {
	*addr = data;
}

// off in word, not byte
int touch_sdram (uint32_t off) {
	uint32_t data = rand();
	write_sdram(((uint32_t *)virtual_base_sdram) + off, data);
	uint32_t x = read_sdram(((uint32_t *)virtual_base_sdram) + off);
	if (x == data) {
		printf("touche word off: %x, PA: %x success \n", off, (sdram_pa_base) + (off * 4));
		return 0;
	} else {
		printf("touche PA %x fail \n", (sdram_pa_base) + (off * 4));
		return -1;
	}
}

int main () {
	init_sdram();
	touch_sdram(0xffffff);
	clean_sdram();
	return( 0 );
}
