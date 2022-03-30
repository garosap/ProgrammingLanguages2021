import sys
from collections import deque

def checkSorted(q):
    i = 1
    while i < len(q):
        if(q[i] < q[i-1]):
            return False
        i += 1    
    return True

def qorder(q, s, path):
    tempQ = q[1:]
    tempS = s[:] + [q[0]]

    path += 'Q'
    return {"queue": tempQ, "stack": tempS, "path": path}

def sorder(q, s, path):
    tempQ = q[:] + [s[-1]]
    tempS = s[:-1]

    path += 'S'
    return {"queue": tempQ, "stack": tempS, "path": path}
    
inputFile = open(sys.argv[1], 'r')
inputArray = inputFile.read().split() # Splits input to an array of integers

N = int(inputArray[0])
inputArray.pop(0) # Removes the first element of a list

inputFile.close()
    
queue = []

for i in range(N):
    queue.append(int(inputArray[i]))


stack = []
answerTree = deque([])
answerTree.append({"queue": queue, "stack": stack, "path": ''})

solved = False
answer = ''
visited = { str((queue, stack))}

while(not solved):
    reps = len(answerTree)
    for i in range(reps):
        q = answerTree.popleft()
        if(checkSorted(q["queue"]) and len(q["queue"]) == N ):
            solved = True
            if q["path"] == '':
                answer = 'empty'
            else:
                if(answer):
                    answer = min(answer, q["path"])
                else:
                    answer = q["path"]
        if(not solved):
            if(q["queue"]):
                temp = qorder(q["queue"], q["stack"], q["path"])
                if str((temp["queue"], temp["stack"] )) not in visited: 
                    answerTree.append(temp)
                    visited.add(str((temp["queue"], temp["stack"] )))
            if(q["stack"]):
                answerTree.append(sorder(q["queue"], q["stack"], q["path"]))

print(answer)

# answerTree = [[{"stack": stack, "queue": queue}], [{stackQ, queueQ, path:Q}, {stackS, queueS, path: S}], [{stackQQ, queueQQ}, {stackQS, queueQS}, {}, {}] ]

# answerTree = [{"fromState":"init", "move":Q, S},  {0, Q}, {0, S}, {1, Q}, {1, S}, {2, Q}, {2, S}]