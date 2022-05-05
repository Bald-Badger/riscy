#ifndef _PERF_HPP_
#define _PERF_HPP_

	#include <iostream>
	#include <stdlib.h>
	#include <stdio.h>
	#include "printf.h"

	constexpr int row = 3;
	constexpr int col = 3;

	void printBoard(char board[row][col]);
	void setBoard(char board[row][col]);
	void getInput(char board[row][col], int *rowInput, int *colInput, char team);
	int bot(char board[row][col]);
	int game(char board[row][col]);
	int checkAvailable(char board[row][col], int rowInput, int colInput);
	int checkWinner(char board[row][col]);

#endif
