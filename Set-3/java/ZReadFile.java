import java.io.File;  // Import the File class
import java.io.FileNotFoundException;  // Import this class to handle errors
import java.util.Scanner; // Import the Scanner class to read text files



public class ZReadFile {
    private int[] carList;
    private int carCount, cityCount;

    public  ZReadFile(String filename) {
        try {
            File myObj = new File(filename);
            Scanner myReader = new Scanner(myObj);
            

            int cities = myReader.nextInt();
            int cars = myReader.nextInt();

            int[] array = new int[cars];
            int i = 0;
            while (myReader.hasNext()) {
                int data = myReader.nextInt();
                // System.out.println(data);
                array[i] = data;
                i++;
            }

            carCount = cars;
            cityCount = cities;
            carList = array;
            
            myReader.close();
          } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
          }
        }

        public int[] getInputArray(){
            return carList;
        }

        public int getCarCount(){
            return carCount;
        }

        public int getCityCount(){
            return cityCount;
        }


    // public static void main(String[] args) {
    //     ReadFile next = new ReadFile("r1.txt");
    // }
}