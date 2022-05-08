#ifndef _TTT_HPP_
#define _TTT_HPP_

	#include "printf.h"
	#include "Serial.hpp"

	constexpr int row = 3;
	constexpr int col = 3;

	void ttt();
	void printBoard(char board[row][col]);
	void setBoard(char board[row][col]);
	void getInput(char board[row][col], int *rowInput, int *colInput, char team);
	int bot(char board[row][col]);
	int game(char board[row][col]);
	int checkAvailable(char board[row][col], int rowInput, int colInput);
	int checkWinner(char board[row][col]);

#endif
