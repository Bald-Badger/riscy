#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "include/hps.h"

void *virtual_base;
int fd;

// phy addr of the axi lw-h2f bridge
const uint32_t h2f_lw_base = (unsigned int) ALT_LWFPGASLVS_OFST;
const uint32_t h2f_base = (unsigned int) 0xC0000000;

// memory offset if the axi slave from the base of lw axi hwf beridge
uint32_t 	offset = 0x4000000;

// phy addr of the device in /dev/mem
// updated in init();
uint32_t	mem_address;

// mem size of the device
uint32_t	mem_size = 0x400;

uint32_t alloc_mem_size, page_mask, page_size;

int init () {
	mem_address = h2f_base + offset;
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( -1 );
	}
	page_size = sysconf(_SC_PAGESIZE);
	alloc_mem_size = (((mem_size / page_size) + 1) * page_size);
	page_mask = (page_size - 1);
	virtual_base = mmap( NULL, alloc_mem_size, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, (mem_address & ~page_mask) );
	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( -1 );
	}
	return (0);
}

int clean () {
	if( munmap( virtual_base, alloc_mem_size ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( -1 );
	}
	close( fd );
	return (0);
}

void touch () {
	uint32_t data = rand();
	*((uint32_t *)virtual_base + 0x300) = data;
	int32_t x = *((uint32_t *)virtual_base + 0x300);
	printf("touching PA: 0x%x\n", mem_address);
	printf("touching VA: %p\n", virtual_base);
	usleep( 100*1000 );
	if (x == data) {
		printf("touch success\n");
	} else {
		printf("touch fail\n");
	}
}

int main () {
	init();
	touch();
	clean();
	return( 0 );
}
