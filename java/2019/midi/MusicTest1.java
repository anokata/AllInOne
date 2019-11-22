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

    static int noteidx = 0;
    public void note(Track t, int n) throws InvalidMidiDataException {
            ShortMessage a = new ShortMessage();
            a.setMessage(144, 1, n, 100);
            MidiEvent noteOn = new MidiEvent(a, noteidx);
            t.add(noteOn);
            noteidx+=3;

            ShortMessage b = new ShortMessage();
            a.setMessage(128, 1, n, 100);
            MidiEvent noteOff = new MidiEvent(b, noteidx);
            t.add(noteOff);
            noteidx+=3;
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

            ShortMessage f = new ShortMessage();
            f.setMessage(192, 1, 102, 0);
            MidiEvent fi = new MidiEvent(f, 1);
            t.add(fi);

            ShortMessage a = new ShortMessage();
            a.setMessage(144, 1, 44, 100);
            MidiEvent noteOn = new MidiEvent(a, 1);
            t.add(noteOn);

            ShortMessage b = new ShortMessage();
            a.setMessage(128, 1, 44, 100);
            MidiEvent noteOff = new MidiEvent(b, 2);
            t.add(noteOff);

            note(t, 47);
            note(t, 50);
            note(t, 10);
            note(t, 100);

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
