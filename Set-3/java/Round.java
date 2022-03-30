public class Round {
  // The main function.
  public static void main(String args[]) {

    ZReadFile inputRead = new ZReadFile(args[0]);

    // int[] inputList = {2, 0, 2, 2};
    int[] inputList = inputRead.getInputArray();
    int carCount = inputRead.getCarCount();
    int cityCount = inputRead.getCityCount();

    RoundState initial = new RoundState(inputList, carCount, cityCount);
    // initial.solve();
    initial.printResult();

  }

}
