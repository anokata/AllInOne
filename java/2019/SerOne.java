import java.io.*;

class SerOne implements Serializable {
    int x;
    public static void main(String[] args) {
        SerOne a = new SerOne();
        a.x = 3;
        try {
            FileOutputStream fs = new FileOutputStream("SerOne.ser");
            ObjectOutputStream os = new ObjectOutputStream(fs);
            os.writeObject(a);
            os.close();
        } catch (Exception e) {}
    }
}
