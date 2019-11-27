import java.io.*;
import javax.sound.midi.*;

class SerOne implements Serializable {
    int x;
    transient int y; // Not save
    public static void main(String[] args) {
        SerOne a = new SerOne();
        System.out.println(a.hashCode());
        a.x = 3;
        a.y = 3;
        System.out.println("x " + a.x + " y " + a.y );
        try {
            Sequencer player = MidiSystem.getSequencer();
            FileOutputStream fs = new FileOutputStream("SerOne.ser");
            ObjectOutputStream os = new ObjectOutputStream(fs);
            os.writeObject(a);
            os.writeObject(player);
            os.close();
        } catch (Exception e) {e.printStackTrace();}
        try {
            FileInputStream fs = new FileInputStream("SerOne.ser");
            ObjectInputStream os = new ObjectInputStream(fs);
            SerOne s = (SerOne) os.readObject();
            System.out.println(s.hashCode());
            System.out.println("x " + s.x + " y " + s.y );
            Sequencer player = (Sequencer) os.readObject();
            System.out.println(player.hashCode());
            System.out.println(player.getClass());
            os.close();
        } catch (Exception e) {e.printStackTrace();}
    }

    SerOne() {
        System.out.println("Construct!");
    }
}
