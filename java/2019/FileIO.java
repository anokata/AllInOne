import java.io.*;
class FileIO {
    public static void main(String[] args) {
        try {
            FileWriter f = new FileWriter("tstjava");
            f.write("hi file");
            f.close();
        } catch (IOException e) {e.printStackTrace();}
    }

}
