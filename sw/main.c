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
uint32_t 	offset = 0x0000000;

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

uint32_t read (uint32_t * addr) {
	return *((uint32_t *)addr);
}

void write (uint32_t* addr, uint32_t data) {
	*((uint32_t *)addr) = data;
}

void touch () {
	uint32_t data = 0x12345678;
	uint32_t* addr_base = ((uint32_t *)mem_address);
	uint32_t off = 0x0;
	uint32_t* addr = addr_base + off;
	printf ("writing to addr: %p ...\n", addr);
	write(addr, data);
	usleep(1000);
	printf ("reading from addr: %p ...\n", addr);
	uint32_t rddata = read(addr);
	if (rddata == data) {
		printf("data match\n");
	} else begin {
		printf("data mismatch\n");
	}
}

int main () {
	init();
	touch();
	clean();
	return( 0 );
}
