#include <iostream>
#include <fstream>

using namespace std;

int pos(int i, int j, int N, int M) {
    return M*i + j;
}

int check(int i, int j, int N, int M, char *a, int *b) {
    int position = pos(i, j, N, M);

    if(b[position] == 1 || b[position] == -1) {
        return b[position];
    }

    else if(b[position] == 2) {
        return -1;
    }

    else switch (a[position]) {
        case 'U':
            if(i == 0) {
                return 1;
            }
            else {
                b[pos(i, j, N, M)] = 2;
                b[pos(i - 1, j, N, M)] = check(i - 1, j, N, M, a, b);
                return b[pos(i - 1, j, N, M)];
            }
            break;

        case 'D':
            if(i == N - 1) {
                return 1;
            }
            else {
                b[pos(i, j, N, M)] = 2;
                b[pos(i + 1, j, N, M)] = check(i + 1, j, N, M, a, b);
                return b[pos(i + 1, j, N, M)];
            }
            break;

        case 'L':
            if(j == 0) {
                return 1;
            }
            else {
                b[pos(i, j, N, M)] = 2;
                b[pos(i, j - 1, N, M)] = check(i, j - 1, N, M, a, b);
                return b[pos(i, j - 1, N, M)];
            }
            break;

        case 'R':
            if(j == M - 1) {
                return 1;
            }
            else {
                b[pos(i, j, N, M)] = 2;
                b[pos(i, j + 1, N, M)] = check(i, j + 1, N, M, a, b);
                return b[pos(i, j + 1, N, M)];
            }
            break;       
        
        default:
            return 666;
            break;
    }
}

int main(int argc, char * argv[]) {

    int N, M;

    fstream fin(argv[1], fstream::in);
    fin >> N;
    
    fin  >> M;

    char a[1000000];
    int i = 0;

    while (fin >> a[i]) {
        i++;
    }
     


    //0 -> unvisited, 1 -> success, -1 -> failure, 2 -> visited
    int b[1000000] = {0};
    int ans = 0;
    


    for(int i = 0; i < N; i++){
        for(int j = 0; j < M; j++) {
            b[pos(i, j, N, M)] = check(i, j, N, M, a, b);
            if(b[pos(i, j, N, M)] == -1) {
                ans++;
            }
        }
    }

    cout << ans << endl;
}