#include "test.h"

int main() {
	int x = 2;
	int z;
	int answer = 4;
	z = foo(x);

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
	printf("answer is %d\n", z);
	return 0;
	#endif /* TB */
}

int foo(int n) {
	return n + n;
}
