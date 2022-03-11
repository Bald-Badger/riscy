#include "./test.h"
#include <stdint.h>
#include <stdio.h>

// int32_t arr[10] = {0,1,2,3,4,5,6,7,8,9};

int main() {
	int x = 2;
	int y = 0;
	int answer = 2;

	y = foo(x);
	
	if (y == answer) {
		#ifdef TB
			goto PASS;
		#endif
	} else {
		#ifdef TB
			goto FAIL;
		#endif
	}
	
	#ifdef TB
	FAIL:
		__asm__("li a0, 0");
		__asm__("li a7, 93");
		__asm__("ecall");
	PASS:
		__asm__("li a0, 42");
		__asm__("li a7, 93");
		__asm__("ecall");
	#else
	printf("answer is %d\n", y);
	return 0;
	#endif /* TB */
}

int foo(int n){
	if (n <= 1)
		return n;
	return foo(n - 1) + foo(n - 2);
}
