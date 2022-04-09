#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
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

uint32_t swap_endian (uint32_t in) {
	return 	((in>>24)&0xff) |			// move byte 3 to byte 0
			((in<<8)&0xff0000) |		// move byte 1 to byte 2
			((in>>8)&0xff00) |		// move byte 2 to byte 1
			((in<<24)&0xff000000);
}

void boot_load (char* filename) {
	// prep work, accocate memory
	int i;
	FILE* file_ptr;
	file_ptr = fopen(filename,"rb");
	if (!file_ptr) {
		perror("fopen");
		exit(EXIT_FAILURE);
	}

	struct stat st;
    if (stat(filename, &st) == -1) {
        perror("stat");
        exit(EXIT_FAILURE);
    }

	uint32_t instr_size_word;
	instr_size_word = (st.st_size) >> 2;
	printf("bootloader start, boot sector size: %d words\n", instr_size_word);

	char* instr_arr_byte = malloc(st.st_size);
	uint32_t* instr_arr = (uint32_t*)instr_arr_byte;

	fread(instr_arr_byte, st.st_size, 1, file_ptr);
	fclose(file_ptr);

	usleep(100);

	for (i = 0; i < 20; i++) {
		printf("%x\n", instr_arr[i]);
	}

	// swap the endianess of each instruction as we are using big endian for now
	
	for (i = 0; i < instr_size_word; i++) {
		instr_arr[i] = swap_endian(instr_arr[i]);
	}

	// map sdram into our own memory space
	uint32_t* sdram_vp = (uint32_t*)init_sdram();


	// write the data into sdram
	for (i = 0; i < instr_size_word; i++) {
		write_sdram(sdram_vp + i, instr_arr[i]);
	}

	// read sdram to check data corruption
	uint32_t sanity_check;
	int err = 0;
	for (i = 0; i < instr_size_word - 1; i++) {
		sanity_check = read_sdram(sdram_vp + i);
		if (sanity_check != instr_arr[i]) {
			if (err == 0) {
				printf("data mismatch at word %d\n",i);
				printf("bootload failed\n");
				err = 1;
			}
			
		}
	}

	// unmap sdram from our memory space
	clean_sdram(sdram_vp);

	// free allocated pointers
	free(instr_arr);

	// display message;
	if (err == 0) {
		printf("bootload success\n");
	}
}


void smoke_test () {
	void* sdram_vp = init_sdram();
	touch_sdram(sdram_vp, 0xffffff);
	clean_sdram(sdram_vp);

	void* seg_vp = (void*)(init_seg());
	set_seg (seg_vp, 0x00123456);
	clean_seg(seg_vp);
}

/*
	uint32_t instr_arr[1000];
	FILE* ptr;
	ptr = fopen("instr.bin","rb");
	fread(instr_arr, sizeof(instr_arr), 1, ptr);
	int i;
	for (i = 0; i < 10; i++) {
		printf("%x\n", instr_arr[i]);
	}
*/

int main () {
	boot_load("instr.bin");
}
