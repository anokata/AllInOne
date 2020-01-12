import javax.sound.midi.*;
import java.util.*;

class BeatModel implements BeatModelInterface {
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

    void setUpMidi() {
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
        beatObservers.remove(o);
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
        bpmObservers.remove(o);
    }

}

