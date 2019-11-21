import javax.sound.midi.*;
import static java.lang.System.out;

class MusicTest1 {
    public static void main(String[] args) {
        MusicTest1 mt = new MusicTest1();
        mt.play();
    }

    public void play() {
        Sequencer sequencer = MidiSystem.getSequencer();
        out.println("get it");
    }
}
