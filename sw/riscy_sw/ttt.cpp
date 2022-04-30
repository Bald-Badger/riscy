#include <iostream>
#include <stdlib.h>
#include <stdio.h>

// using namespace std;

constexpr int row = 3;
constexpr int col = 3;

void printBoard(char board[row][col]);
void setBoard(char board[row][col]);
void getInput(char board[row][col], int *rowInput, int *colInput, char team);
int bot(char board[row][col]);
int game(char board[row][col]);
int checkAvailable(char board[row][col], int rowInput, int colInput);
int checkWinner(char board[row][col]);


int main() {
	char board[row][col];
	game(board);
}


int game(char board[row][col]) {
	int rowInput, colInput;
	setBoard(board);
	printBoard(board);

	// game loop
	while(checkWinner(board) == 0) {

		getInput(board, &rowInput, &colInput, 'X');
		printBoard(board);
		if (checkWinner(board) == 1) {
			printf("X Wins!\n");
			break;
		}

		getInput(board, &rowInput, &colInput, 'O');
		//bot(board);
		printBoard(board);
		if (checkWinner(board) == -1) {
			printf("O Wins!\n"); 
			break;
		}
	}

	return 0;
}

void printBoard(char board[row][col]) {
	// print board
	printf("\n");
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			printf("%c",board[i][j]);
		}
		printf("\n");
	}
}

void setBoard(char board[row][col]) {
	// reset board
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			board[i][j] = '0';
		}
	}
}

int bot(char board[row][col]) {
	// bot playing against human
	int random = rand() % 9;

	int botRow = random/3;
	int botCol = random - botRow * 3;

	if(checkAvailable(board, botRow, botCol) == 1) {
		board[botRow][botCol] = 'O';
		return 0;
	}
	else {
		bot(board);
		return 0;
	}
}

void getInput(char board[row][col], int *rowInput, int *colInput, char team) {
	// get input from user (row and column)
	printf("Enter row: ");
	cin >> *rowInput;
	(*rowInput)--;
	printf("Enter column: ");
	cin >> *colInput;
	(*colInput)--;

	if(checkAvailable(board, *rowInput, *colInput) == -1) {
		getInput(board, rowInput, colInput, team);
	}
	else {
		board[*rowInput][*colInput] = team;
	}
}

int checkAvailable(char board[row][col], int rowInput, int colInput) {
	// check if square is available
	if (board[rowInput][colInput] == '0') {return 1;}
	else {return -1;}

	return 0;
}

int checkWinner(char board[row][col]) {
	// check if there has been a winner

	// rows
	for (int i = 0; i < row; i++) {
		if (board[i][0] == 'X' && board[i][1] == 'X' && board[i][2] == 'X') {return 1;}
		if (board[i][0] == 'O' && board[i][1] == 'O' && board[i][2] == 'O') {return -1;}
	}

	// columns
	for (int i = 0; i < row; i++) {
		if (board[0][i] == 'X' && board[1][i] == 'X' && board[2][i] == 'X') {return 1;}
		if (board[0][i] == 'O' && board[1][i] == 'O' && board[2][i] == 'O') {return -1;}
	}

	// diagonals
	if (board[0][0] == 'X' && board[1][1] == 'X' && board[2][2] == 'X') {return 1;}
	if (board[0][0] == 'O' && board[1][1] == 'O' && board[2][2] == 'O') {return -1;}
	if (board[2][0] == 'X' && board[1][1] == 'X' && board[0][2] == 'X') {return 1;}
	if (board[2][0] == 'O' && board[1][1] == 'O' && board[0][2] == 'O') {return -1;}

	return 0;
}