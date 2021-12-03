#include "test.h"

int main() {
	int x;
	int y;
	int z = 0;
	for (x = 0; x <2; x++) {
		z = z + 3;
		for (y = 0; y < 3; y++) {
			z = z + 5;
		}
		z = z - 7;
	}

	int answer = 1110;

	if (z == answer) {
		#ifdef TB
			goto PASS;
		#endif
	} else {
		#ifdef TB
			goto FAIL;
		#endif
	}
	
	#ifdef TB
	PASS:
		__asm__("li a0, 42");
		__asm__("li a7, 93");
		__asm__("ecall");
	FAIL:
		__asm__("li a0, 0");
		__asm__("li a7, 93");
		__asm__("ecall");
	#else
	return 0;
	#endif /* TB */
}
