#include <stdio.h>
#include <stdlib.h>
 
/* For a given array arr[], returns the maximum j – i such that
    arr[j] > arr[i] */
int maxIndexDiff(int arr[], int n)
{
    int maxDiff;
    int i, j;
 
    int* LMin = (int*)malloc(sizeof(int) * n);
    int* RMax = (int*)malloc(sizeof(int) * n);
 
    /* Construct LMin[] such that LMin[i] stores the minimum value
       from (arr[0], arr[1], ... arr[i]) */
    LMin[0] = arr[0];
    for (i = 1; i < n; ++i){
        LMin[i] = min(arr[i], LMin[i - 1]);
    }

    for(int i = 0; i <n; i++) printf("%i ", LMin[i]);
    printf("\n");
    
 
    /* Construct RMax[] such that RMax[j] stores the maximum value
       from (arr[j], arr[j+1], ..arr[n-1]) */
    RMax[n - 1] = arr[n - 1];
    for (j = n - 2; j >= 0; --j){
        RMax[j] = max(arr[j], RMax[j + 1]);
    }
    
    for(int i = 0; i <n; i++) printf("%i ", RMax[i]);
    printf("\n");   
 
    /* Traverse both arrays from left to right to find optimum j - i
        This process is similar to merge() of MergeSort */
    i = 0, j = 0, maxDiff = -1;
    while (j < n && i < n) {
        if (LMin[i] <= RMax[j]) {
            maxDiff = max(maxDiff, j - i );
            printf("%i  \n", maxDiff);
            j = j + 1;
        }
        else if(j > i)
            i = i + 1;
        else 
            j = j + 1;     
    }
 
    return maxDiff;
}


int main(int argc, char *argv[]) {

    FILE *in_file  = fopen(argv[1], "r"); // read only 
    if (in_file == NULL) {   
        printf("Error! Could not open file\n"); 
        exit(-1);
    } 

    int D;
    fscanf(in_file, "%i", & D);

    int hospitals;
    fscanf(in_file, "%i", & hospitals);

    int arr[1000000];

    for(int i = 0; i < D; i++){
        int temp;
        fscanf(in_file, "%i", & temp);
        arr[i] = temp; 
    }


    for(int i = 0; i < D; i++) {
        arr[i] = -arr[i];
        arr[i] -= hospitals;
    }

    int prefixArr[D+1];
    prefixArr[0] = 0;

    for(int i = 1; i<D+1; i++) {
        prefixArr[i] = prefixArr[i-1] + arr[i-1];
        
    }
    

    printf("%i\n", maxIndexDiff(prefixArr, D + 1));
    

    return 0;
}
