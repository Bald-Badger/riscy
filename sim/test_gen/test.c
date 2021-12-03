#include "test.h"

int main() {
	int answer = 34;
	int z = fib(9);

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

int fib(int n) {
	if (n <= 1)
		return n;
	return fib(n-1) + fib(n-2);
}