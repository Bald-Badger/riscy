#include "test.h"

int main() {
	int x;
	int z = 0;
	for (x = 0; x <3; x++) {
		z = z + 2;
	}

	int answer = 6;

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
