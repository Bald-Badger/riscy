#ifndef _SYSCALL_HPP_
#define _SYSCALL_HPP_

	#include <sys/stat.h>
	#include <newlib.h>
	#include <unistd.h>
	#include <errno.h>
	#include <reent.h>

	static char* __heap_start = (char*)0x00080000;
	static char *brk = __heap_start;

	int _brk(void *addr)
	{
		brk = (char*)addr;
		return 0;
	}

	void *_sbrk(int incr) {
		static unsigned char *heap = NULL;
		unsigned char *prev_heap;

		if (heap == NULL) {
			heap = (unsigned char *) __heap_start;
		}
		prev_heap = heap;

		heap += incr;

		return prev_heap;
	}

	void * _sbrk_r (struct _reent *ptr, ptrdiff_t incr) {
		return _sbrk(incr);
	}

#endif
