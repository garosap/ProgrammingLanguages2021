import sys
from array import *
from collections import deque
 


if len(sys.argv) <= 1:
    print("Please provide a txt input file.")
    exit()

inputFile = open(sys.argv[1], "r")
inputArray = inputFile.read().split() # Splits input to an array of integers and strings

N = int(inputArray[0])
inputArray.pop(0) # Removes the first element of a list

M = int(inputArray[0])
inputArray.pop(0)

#inputArray now only includes strings

# String -> Char list
def decompose(str):
    return list(str)

def check(i, j):
    if(inputArray[i][j] == 1 or  inputArray[i][j] == -1):
        return {"ans": inputArray[i][j]}
    elif(inputArray[i][j] == 2):
        return {"ans": -1}
    
    if inputArray[i][j] == "U":
        if i == 0:
            return {"ans": 1}
        else:
            return {"ans": 2, "nextI": i-1, "nextJ": j}
    elif inputArray[i][j] == "D":
        if i == N - 1:
            return {"ans": 1}
        else:
            return {"ans": 2, "nextI": i+1, "nextJ": j}
    elif inputArray[i][j] == "L":
        if j == 0:
            return {"ans": 1}
        else:
            return {"ans": 2, "nextI": i, "nextJ": j-1}
    elif inputArray[i][j] == "R":
        if j == M - 1:
            return {"ans": 1}
        else:
            return {"ans": 2, "nextI": i, "nextJ": j+1}
        



inputArray = list(map(decompose, inputArray))
# inputArray is now 2-D char array

ans = 0
stack = deque()

for i in range(N):
    for j in range(M):
        
        
        checkResponse = check(i, j)
        inputArray[i][j] = checkResponse["ans"]
        fakeI = i
        fakeJ = j
        while(checkResponse["ans"] == 2):
            stack.append({"i": fakeI, "j": fakeJ})
            fakeI = checkResponse["nextI"]
            fakeJ = checkResponse["nextJ"]
            checkResponse =  check(checkResponse["nextI"], checkResponse["nextJ"])
            inputArray[fakeI][fakeJ] = checkResponse["ans"]

        while(stack):
            popedItem = stack.pop()
            inputArray[popedItem["i"]][popedItem["j"]] = checkResponse["ans"]


        if(inputArray[i][j] == -1):
            ans += 1    


print(ans)

inputFile.close()        