// #define TB	// shoule be passed by makefile e.g. gcc -D TB
#include "test.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#ifndef TB
#include <stdio.h>
#endif

int main() {

/*
	int a = 2 + 3;
	if (a != 5) {goto FAIL;}
	goto PASS;
*/

	char kotoba[15] = "0123456789\r\n";
	
	if (kotoba[0] != '0') {goto FAIL;}
	if (kotoba[1] != '1') {goto FAIL;}
	if (kotoba[2] != '2') {goto FAIL;}
	if (kotoba[3] != '3') {goto FAIL;}
	if (kotoba[4] != '4') {goto FAIL;}
	if (kotoba[5] != '5') {goto FAIL;}
	if (kotoba[6] != '6') {goto FAIL;}
	if (kotoba[7] != '7') {goto FAIL;}
	if (kotoba[8] != '8') {goto FAIL;}
	if (kotoba[9] != '9') {goto FAIL;}
	goto PASS;


	FAIL:
		#ifdef TB
		__asm__("li a0, -1");
		__asm__("li a7, 93");
		__asm__("ecall");
		#else
		printf("test failed");
		return 0;
		#endif /* TB */
	PASS:
		#ifdef TB
		__asm__("li a0, 42");
		__asm__("li a7, 93");
		__asm__("ecall");
		#else
		printf("test passed\n");
		return 0;
		#endif /* TB */
	
	return 0;
}
