import javax.sound.midi.*;
import static java.lang.System.out;

class MusicTest1 {
    public static void main(String[] args) {
        MusicTest1 mt = new MusicTest1();
        //handleRisk();
        out.println("start");
        mt.play();
        out.println("end");
    }

    public void play() {
        Sequencer player;
        try {
            player = MidiSystem.getSequencer();
            out.println("get it");
            player.open();
            out.println("opened");
            Sequence seq = new Sequence(Sequence.PPQ, 4);
            out.println("created seq");
            Track t = seq.createTrack();
            out.println("created track");

            ShortMessage a = new ShortMessage();
            a.setMessage(144, 1, 44, 100);
            MidiEvent noteOn = new MidiEvent(a, 1);
            t.add(noteOn);

            ShortMessage b = new ShortMessage();
            a.setMessage(128, 1, 44, 100);
            MidiEvent noteOff = new MidiEvent(b, 2);
            t.add(noteOff);

            player.setSequence(seq);
            out.println("created midi");
            player.start();
            out.println("played");
        } catch (MidiUnavailableException ex) {
            System.out.println("Fail");
        } catch (InvalidMidiDataException ex) {
            System.out.println("Fail data");
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
            return;
        } finally {
            out.println("Нисмотря ни на что! (даже return)");
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
