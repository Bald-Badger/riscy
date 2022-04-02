#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "include/hps.h"
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

int main() {

	void *virtual_base;
	int fd;
	void *h2p_lw_led_addr;

	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
	
	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	// connected to lw h2f master
	h2p_lw_led_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_LED_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	printf("virtual base is : %p\n", virtual_base);
	usleep( 100*1000 );
	printf("seg VA is : %p\n", h2p_lw_led_addr);
	usleep( 100*1000 );
	printf("offset is %x\n", ALT_LWFPGASLVS_OFST);
	usleep( 100*1000 );

	// toggle the LEDs a bit

/*
	for (uint32_t i = 0; i < 60; i ++) {
		printf( "looping\n" );
		// control led
		*(uint32_t *)h2p_lw_led_addr = i; 
		usleep( 100*1000 );

	}
*/
	printf("cast begin \n");
	usleep( 100*1000 );
	uint32_t x = *(uint32_t *)h2p_lw_led_addr;
	//*(uint32_t *)h2p_lw_led_addr = (uint32_t)0x12345678;
	usleep( 100*1000 );
	printf("cast end \n");

	// clean up our memory mapping and exit
	
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}
