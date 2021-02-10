/*
 * Copyright 1991-2020 Mentor Graphics Corporation
 *
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
 * LICENSE TERMS.
 *
 * Simple SystemVerilog DPI Example - C function to compute fibonacci seq.
 */
#include "alu_tb.h"
#include <stdio.h>
#include <stdlib.h>
#include "include/Python.h"

int test(int ip) {
	printf("will it?\n");
	return ip + 1;
}
