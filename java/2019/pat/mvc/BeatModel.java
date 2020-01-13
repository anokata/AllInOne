import javax.sound.midi.*;
import java.util.*;

class BeatModel implements BeatModelInterface, MetaEventListener {
    public static void main(String[] args) {
        BeatModel app = new BeatModel();
    }

    Sequencer sequencer;
    Sequence sequence;
    Track track;
    ArrayList<BeatObserver> beatObservers = new ArrayList<BeatObserver>();
    ArrayList<BPMObserver> bpmObservers = new ArrayList<BPMObserver>();
    int bpm = 90;

    BeatModel () {
    }

    void buildTrackAndStart() {
    }

    public void initialize() {
        setUpMidi();
        buildTrackAndStart();
    }

    public void on() {
        sequencer.start();
        setBPM(90);
    }

    public void off() {
        setBPM(0);
        sequencer.stop();
    }

    public void setBPM(int bpm) {
        this.bpm = bpm;
        sequencer.setTempoInBPM(getBPM());
        notifyBPMObservers();
    }

    public int getBPM() {
        return bpm;
    }

    public void beatEvent() {
        notifyBeatObservers();
    }
    //561
    public void registerObserver(BeatObserver o) {
        beatObservers.add(o);
    }
    
    public void notifyBeatObservers() {
        for (BeatObserver b : beatObservers) {
            b.updateBeat();
        }
    }

    public void removeObserver(BeatObserver o) {
        if (beatObservers.indexOf(o) >= 0) {
            beatObservers.remove(o);
        }
    }

    public void registerObserver(BPMObserver o) {
        bpmObservers.add(o);
    }

    void notifyBPMObservers() {
        for (BPMObserver b : bpmObservers) {
            b.updateBPM();
        }
    }

    public void removeObserver(BPMObserver o) {
        if (bpmObservers.indexOf(o) >= 0) {
            bpmObservers.remove(o);
        }
    }


    public void meta(MetaMessage msg) {
        if (msg.getType() == 47) {
            beatEvent();
            sequencer.start();
            setBPM(getBPM());
        }
    }

    public void setUpMidi() {
        try {
            sequencer = MidiSystem.getSequencer();
            sequencer.open();
            sequencer.addMetaEventListener(this);

        } catch (Exception ex) { ex.printStackTrace(); }
    }

}

