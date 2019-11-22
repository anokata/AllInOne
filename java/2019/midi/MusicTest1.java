import javax.sound.midi.*;
import static java.lang.System.out;

class MusicTest1 {
    public static void main(String[] args) {
        MusicTest1 mt = new MusicTest1();
        handleRisk();
        out.println("start");
        mt.play();
        out.println("end");
    }

    public void play() {
        try {
            Sequencer sequencer = MidiSystem.getSequencer();
            out.println("get it");
        } catch (MidiUnavailableException ex) {
            System.out.println("Fail");
        }
    }

    public static void handleRisk() {
        try {
            risk();
        } catch (Exception e) {
            out.println("can't handle");
        }

        try {
            nullrisk();
        } catch (NullPointerException e) {
            out.println("bad example");
        }
    }

    public static void risk() throws Exception {
        throw new Exception();
    }

    public static void nullrisk() {
        Object o = null;
        o.getClass();
    }
}
