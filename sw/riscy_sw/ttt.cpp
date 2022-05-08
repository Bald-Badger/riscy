#include "ttt.hpp"
#include "Serial.hpp"


int rowInput;
int colInput;

Serial* myserial;


void ttt() {
	myserial = new Serial();
	char board[row][col];
	setBoard(board);
	printBoard(board);
	// game(board);
}


int game(char board[row][col]) {
	setBoard(board);
	printBoard(board);

	// game loop
	while(checkWinner(board) == 0) {

		getInput(board, &rowInput, &colInput, 'X');
		printBoard(board);
		if (checkWinner(board) == 1) {
			printf_("X Wins!\r\n");
			break;
		}

		getInput(board, &rowInput, &colInput, 'O');
		//bot(board);
		printBoard(board);
		if (checkWinner(board) == -1) {
			printf_("O Wins!\r\n"); 
			break;
		}
	}

	return 0;
}

void printBoard(char board[row][col]) {
	// print board
	printf_("\r\n");
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			printf_("%c",board[i][j]);
		}
		printf_("\r\n");
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


void getInput(char board[row][col], int *rowInput, int *colInput, char team) {
	// get input from user (row and column)
	printf_("Enter row: ");
	//cin >> *rowInput;
	(*rowInput)--;
	printf_("Enter column: ");
	//cin >> *colInput;
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
