import java.util.concurrent.ArrayBlockingQueue;
import java.util.Stack;
import java.util.*;


/* A class implementing the state of the well-known problem with the
 * wolf, the goat and the cabbage.
 */
public class ZState {

    private ArrayBlockingQueue<Integer> queue;
    private Stack<Integer> stack;
    private String path;
    private int N;

    public ZState(int Num, ArrayBlockingQueue<Integer> queueInit, Stack<Integer> stackInit, String pathInit) {
        N = Num; 
        stack = (Stack<Integer>)stackInit.clone();
        queue = new ArrayBlockingQueue<Integer>(N, true, queueInit);
        path = pathInit;
    }

    public void addStack() {
        stack.add(12);
    }



    public void printState() {
        System.out.printf( "Queue: %s Stack: %s Path '%s'\n", queue.toString(), stack.toString(), path);
    }

    public boolean checkQueueSorted() {
        Iterator<Integer> iteratorValues = queue.iterator();
        if(queue.isEmpty()) return true;
        int curr = queue.peek();
        int next = 0;
        while (iteratorValues.hasNext()) {
            next = iteratorValues.next();
            if(curr <= next) curr = next;
            else break;
        }

        return !iteratorValues.hasNext() && (curr <= next);
    }

    public ZState qorder() {
        Stack<Integer> newStack = (Stack<Integer>)stack.clone();
        ArrayBlockingQueue<Integer> newQueue = new ArrayBlockingQueue<Integer>(N, true, queue);
        newStack.push(newQueue.remove());
        ZState result = new ZState(N, newQueue, newStack, path+"Q");
        return result;
    }   

    public ZState sorder() {
        Stack<Integer> newStack = (Stack<Integer>)stack.clone();
        ArrayBlockingQueue<Integer> newQueue = new ArrayBlockingQueue<Integer>(N, true, queue);
        newQueue.add(newStack.pop());
        ZState result = new ZState(N, newQueue, newStack, path+"S");
        return result;
    }   

    public ZState[] nextStates() {
        ZState[] states = new ZState[4];
        int i = 0;
        if(queue.size() > 0){
            ZState qResult = this.qorder();
            if(qResult.getQueueSize() > 0){
                states[i] = qResult.qorder();
                i++;
            }
            if(qResult.getStackSize() > 0){
                states[i] = qResult.sorder();
                i++;
            }
        }
        if(stack.size() > 0){
            ZState sResult = this.sorder();
            if(sResult.getQueueSize() > 0){
                states[i] = sResult.qorder();
                i++;
            }
            if(sResult.getStackSize() > 0){
                states[i] = sResult.sorder();
                i++;
            }
        }

        return states;
    }

    public int getQueueSize() {
        return queue.size();
    }

    public int getStackSize() {
        return stack.size();
    }
    public String getPath() {
        return path;
    }



    @Override
    public String toString() {
      StringBuilder sb = new StringBuilder("");
      sb.append(queue.toString());
      sb.append(stack.toString());
      return sb.toString();
    }
  

    @Override
    public int hashCode() {
        return (17 * queue.hashCode() + 42 * stack.hashCode());
    }
  

}
