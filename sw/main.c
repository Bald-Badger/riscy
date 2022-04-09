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
const uint32_t sdram_range		= 0x03ffffff;	// 0x0 - 0x3ffffff
const uint32_t offset_sdram		= 0x00000000;	// offset from bridge
const uint32_t sdram_size_byte	= 0x04000000;	// 512Mb
const uint32_t sdram_size_word	= 0x01000000;	// 64MB
const uint32_t sdram_pa_base	= h2f_base + offset_sdram;	// PA of sdram from HPS's perspective


// 7-seg display define
const uint32_t seg_range		= 0x0000001f;	// 0x0 - 0x1f
const uint32_t offset_seg		= 0x04000000;	// offset from bridge
const uint32_t seg_size_byte	= 0x00000020;	// 32 bytes
const uint32_t seg_size_word	= 0x00000008;	// 8 words (6 needed)


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

void* init_sdram() {
	return map_addr (sdram_pa_base, sdram_size_byte);
}

int unmap_addr (void* vp_base, u_int32_t unmap_size_byte) {
	if( munmap( vp_base, unmap_size_byte ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		return( -1 );
	}
	return (0);
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
	if (x == data) {
		printf("touche word off: %x, PA: %x success \n", off, (sdram_pa_base) + (off * 4));
		return 0;
	} else {
		printf("touche PA %x fail \n", (sdram_pa_base) + (off * 4));
		return -1;
	}
}

int main () {
	void* sdram_vp = init_sdram();
	touch_sdram(sdram_vp, 0xffffff);
	clean_sdram(sdram_vp);
	return( 0 );
}
