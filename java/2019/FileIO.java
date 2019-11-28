import java.io.*;
class FileIO {
    public static void main(String[] args) {
        writeTest();
        reatTest();
    }

    static void writeTest() {
        try {
            FileWriter f = new FileWriter("tstjava");
            f.write("hi file");
            f.close();
        } catch (IOException e) {e.printStackTrace();}
    }

    static void reatTest() {
        try {
            File file = new File("FileIO.java");
            BufferedReader in = new BufferedReader(new FileReader(file));

            String line = null;

            while ((line = in.readLine()) != null) {
                System.out.println(line);
            }

            in.close();
        } catch (IOException e) {e.printStackTrace();}
    }

}
