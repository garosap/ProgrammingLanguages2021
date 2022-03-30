import java.util.Arrays;

/* A class implementing the state of the well-known problem with the
 * wolf, the goat and the cabbage.
 */
public class RoundState {

  private int carCount, cityCount, optimalSum, optimalTargetCity;

  private int[] cityList, carList;

  public RoundState(int[] carLst, int cars, int cities) {
    carList = carLst;
    carCount =  cars;
    cityCount = cities;
  }

  private void transformArray() {
    int[] finalList = new int[cityCount];
    
    // Arrays.sort(tempList);

    for(int i = 0; i < carCount; i++){
      finalList[carList[i]]++;
    }
    cityList = finalList;

    // System.out.printf("Modified cityList[] : %s %s\n", Arrays.toString(carList), Arrays.toString(finalList));
  }
  

  private int[] calcInitialSumMax() {
    int sum = 0, max = 0;
    int distance = 0;

    for(int i = 0; i < carCount; i++){
      distance = calcDistance(carList[i], 0, cityCount);
      sum += distance;
      max = Math.max(max, distance);
    }
    int[] temp = {sum, max};
    return temp;
    // System.out.printf("Modified cityList[] : %s %s\n", Arrays.toString(carList), Arrays.toString(finalList));
  }

  private static boolean isValid(int sum, int max){
    int temp = (max - (sum - max));
    return temp <= 1;
  }


  public static void main(String[] args){
    int[] testList = {2, 0, 2, 2};
    RoundState testState = new RoundState(testList, 4, 3 );

    solve(testState);
    // System.out.print(calcDistance(4, 1, 5));
    // System.out.printf("Modified cityList[] : %s \n", Arrays.toString(testState.calcInitialSumMax()));

  }

  private static int calcDistance(int source, int destination, int cities){
    if(source <= destination) return destination - source;
    else return cities - source + destination;
  }

  public void printResult() {
    solve(this);
    System.out.printf("%d %d", optimalSum, optimalTargetCity);
  }

  private void setResult(int optSum, int optTargetCity) {
    optimalSum = optSum;
    optimalTargetCity = optTargetCity;
  }


  private int findNextHelper(int curr) {
    int pos;

    if(curr == cityCount-1) pos = 0;
    else pos = curr + 1;
    
    while(cityList[pos] == 0){
      if(pos == cityCount-1 ) pos = 0;
      else pos++;
    }

    return pos;
  }


  private static void solve(RoundState initial) { 
    initial.transformArray();
    int[] initSumMax = initial.calcInitialSumMax();
    int maxDist = initSumMax[1];
    int newSum = initSumMax[0];
    initial.setResult(initSumMax[0], 0);

    int nextToRight = initial.findNextHelper(0);

    for(int i = 1; i < initial.cityCount; i++){

      if(i == nextToRight) nextToRight = initial.findNextHelper(i);
      // System.out.printf("%d %d %b \n", i, nextToRight, i == nextToRight);

      newSum = newSum + initial.carCount - initial.cityCount * initial.cityList[i];
      maxDist = calcDistance(nextToRight, i, initial.cityCount);
      if(isValid(newSum, maxDist) && newSum < initial.optimalSum){
        initial.setResult(newSum, i);
      }
    }

    // System.out.printf("Modified cityList[] : %s %s\n", Arrays.toString(carList), Arrays.toString(finalList));
  }

}
