import java.util.concurrent.ArrayBlockingQueue;
// import java.util.Stack;
import java.util.*;

public class QSsort {   
      public static void main(String args[]) {
        ZReadFilename inputRead = new ZReadFilename(args[0]);
        int N = inputRead.getN();

        int[] inputList = inputRead.getInputArray();

        String path = "";

        ArrayBlockingQueue<Integer> initialQueue = new ArrayBlockingQueue<Integer>(N);

        for(int i = 0; i < N; i++) initialQueue.add(inputList[i]);
        
        Stack<Integer> initialStack = new Stack<Integer>();

        ZState initial = new ZState(N, initialQueue, initialStack, path);

        boolean solved = false;
        String answer = "";

        // HashSet<String> visited = new HashSet<String>();
        HashSet<Integer> visited = new HashSet<Integer>();

        visited.add(initial.hashCode());

        // System.out.printf("%s, %d\n", initial.toString(), initial.hashCode());

        // System.out.printf("%s, %d\n", kap.toString(), kap.hashCode());
        Deque<ZState> answerTree = new ArrayDeque<ZState>();
        answerTree.add(initial);
        
        
        while(!solved){
          int reps = answerTree.size();
          for(int i = 0; i < reps; i++){
            ZState q = answerTree.pop();
           
            if(q.checkQueueSorted() && q.getQueueSize() == N ){
              solved = true;
              if(q.getPath().isEmpty()) answer = "empty";
              else {
                // if(!answer.isEmpty()){
                //   answer = minString(answer, q.getPath());
                // }
                // else answer = q.getPath();
                answer = q.getPath();
              }
              break;
            }
            if(!solved){
              ZState[] next = q.nextStates();
              // q.printState();
              for(int k = 0; k < 4; k++){
                if(next[k] != null){
                  // next[k].printState();
                  // String hash = next[k].toString();
                  Integer hash = next[k].hashCode();

                  if(!visited.contains(hash)){
                    answerTree.add(next[k]);
                    visited.add(hash);
                  }
                } 
              }
            }
          }
        }
        System.out.println(answer);
      }
 
      private static String minString(String one, String two){
        if(one.compareTo(two) < 0) return one;
        else return two;
      }
}