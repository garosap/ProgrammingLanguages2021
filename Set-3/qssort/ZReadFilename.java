import java.io.*;


public class ZReadFilename {
    private int[] input;
    private int Num;

    public  ZReadFilename(String filename) {
        // try {
        //     File myObj = new File(filename);
        //     Scanner myReader = new Scanner(myObj);

        //     int number = myReader.nextInt();

        //     int[] array = new int[number];
        //     int i = 0;
        //     while (myReader.hasNext()) {
        //         int data = myReader.nextInt();
        //         // System.out.println(data);
        //         array[i] = data;
        //         i++;
        //     }

        //     Num = number;
        //     input = array;
            
        //     myReader.close();
        //   } catch (FileNotFoundException e) {
        //     System.out.println("An error occurred.");
        //     e.printStackTrace();
        //   }
        
            BufferedReader objReader = null;
            try {
            String strCurrentLine;
        
            objReader = new BufferedReader(new FileReader(filename));
        
            int number = Integer.parseInt(objReader.readLine());

            String arrayString = objReader.readLine();
            String[] arrayChar = arrayString.split( " ", -1 );

            int[] array = new int[number];
            int i = 0;

            for (String a : arrayChar){
                array[i] = Integer.parseInt(a);
                i++;
            }

            Num = number;
            input = array;
        
            } catch (IOException e) {
        
            e.printStackTrace();
        
            } finally {
        
            try {
            if (objReader != null)
                objReader.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
            }
        }

        public int[] getInputArray(){
            return input;
        }

        public int getN(){
            return Num;
        }

}