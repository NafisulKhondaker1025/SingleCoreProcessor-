#include <stdio.h>

int downLeft(int* row, int* col, int frameR) {
	(*col)--;
	(*row)++;
	return ((*row * frameR) + *col);
}

int rightUp(int *row, int *col, int frameR) {
	(*col)++;
	(*row)--;
	return ((*row * frameR) + *col);
}

int Right(int *row, int *col, int frameR) {
	(*col)++;
	return ((*row * frameR) +* col);
}

int Down(int *row, int *col, int frameR) {
	(*row)++;
	return ((*row * frameR) + *col);
}

void SAD(int fi, int frame[], int window[], int asize[], int row, int col) {
	int sum = 0, k = 0;

	if ((col + asize[3] <= asize[1]) && (row + asize[2] <= asize[0])) {
		printf("%d, ", frame[fi]);

		for (int wi = 0; wi < asize[0] * asize[1]; wi++) {
			sum = sum + abs(frame[fi] - window[wi]);
			printf("Diff %d = %d\n", wi, abs(frame[fi] - window[wi]));
			if (k >= asize[1] - 1) {
				fi = fi + asize[3] - asize[1] + 1;
				k = 0;
			}
			else {
				fi = fi + 1;
				k = k + 1;
			}
		}
	}
}

int main(void) {
	int frame[16];
	int window[] = { 1, 2, 3, 4 };
	int asize[] = { 4, 4, 2, 2 };
	int j = 0;
	int row = 0, col = 0;

	for (int i = 0; i < (asize[0] * asize[1]); i++) {
		frame[i] = i;
		if (i % asize[1] == 0 && i != 0) {
			printf("\n");
		}
		printf("%d\t", i);

	}

	printf("\n\n");

	SAD(j, frame, window, asize, row, col);

	while ((row != (asize[0] - 1)) || (col != (asize[1] - 1))) {

		if (col != (asize[1] - 1)) {
			j = Right(&row, &col, asize[1]);
			SAD(j, frame, window, asize,row, col);
		}

		/*else if ((row == (asize[0] - 1)) && (col == (asize[1] - 1))) {

		}*/

		else {
			j = Down(&row, &col, asize[1]);
			SAD(j, frame, window, asize, row, col);
		}

		while ((row != (asize[0] - 1) && col != 0)) {
			j = downLeft(&row, &col, asize[1]);
			SAD(j, frame, window, asize, row, col);
		}

		if (row != (asize[0] - 1)) {
			j = Down(&row, &col, asize[1]);
			SAD(j, frame, window, asize, row, col);
		}

		else if ((row == (asize[0] - 1)) && (col == (asize[1] - 1))) {

		}

		else {
			j = Right(&row, &col, asize[1]);
			SAD(j, frame, window, asize, row, col);
		}

		while ((row != 0) && (col != (asize[1] - 1))) {
			j = rightUp(&row, &col, asize[1]);
			SAD(j, frame, window, asize, row, col);
		}

	}

	printf("\n\n");

	return 0;
}