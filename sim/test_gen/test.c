#include "./test.h"
#include <stdint.h>
#include <stdio.h>

// int32_t arr[10] = {0,1,2,3,4,5,6,7,8,9};

int main() {

    int arr[] = { 12, 11, 13, 5, 6, 7 };
	int sorted[] = { 5, 6, 7, 11, 12, 13 };
    int arr_size = sizeof(arr) / sizeof(arr[0]);
  
    mergeSort(arr, 0, arr_size - 1);
  
    for (int i = 0; i < arr_size; i++) {
		if (arr[i] != sorted[i]) {
		#ifdef TB
			goto FAIL;
		#endif
		}
	}
	#ifdef TB
		goto PASS;
	#endif

/*
	if (y == answer) {
		#ifdef TB
			goto PASS;
		#endif
	} else {
		#ifdef TB
			goto FAIL;
		#endif
	}
*/	
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

void mergeSort(int arr[], int l, int r)
{
    if (l < r) {
        // Same as (l+r)/2, but avoids overflow for
        // large l and h
        int m = l + (r - l) / 2;
  
        // Sort first and second halves
        mergeSort(arr, l, m);
        mergeSort(arr, m + 1, r);
  
        merge(arr, l, m, r);
    }
}

void merge(int arr[], int l, int m, int r)
{
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;
  
    /* create temp arrays */
    int L[n1], R[n2];
  
    /* Copy data to temp arrays L[] and R[] */
    for (i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[m + 1 + j];
  
    /* Merge the temp arrays back into arr[l..r]*/
    i = 0; // Initial index of first subarray
    j = 0; // Initial index of second subarray
    k = l; // Initial index of merged subarray
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        }
        else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }
  
    /* Copy the remaining elements of L[], if there
    are any */
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }
  
    /* Copy the remaining elements of R[], if there
    are any */
    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }
}