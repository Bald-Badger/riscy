#ifndef _PERF_HPP_
#define _PERF_HPP_

	#define WORD_ALIGN_MASK	0xFFFFFFFC

	// SDRAM DEFINE
	#define SDRAM_START		0x00000000U
	#define SDRAM_SIZE		0x04000000	// 64MB
	#define SDRAM_END		0x03FFFFFF
	#define SDRAM_ADDR_MASK	0x03FFFFFF

	// memory space layout
	#define STACK_START		(SDRAM_END & WORD_ALIGN_MASK)

	// SEG DEFINE
	#define SEG_BASE		0x04000000
	#define SEG_MAX			0x0000001F
	#define SEG_ADDR_MASK	0x0400001C
	#define SEG_DATA_MASK	0x0000000F

	// UART DEFINE
	#define UART_BASE		0x04010000
	#define UART_MAX		0x0401001F
	#define UART_DATA_MASK	0x000000FF
	#define UART_DATA_ADDR	UART_BASE
	#define UART_DLEN_ADDR	0x04010004

#endif
