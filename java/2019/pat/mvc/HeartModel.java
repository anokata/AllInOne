import java.util.*;

public class HeartModel implements HeartModelInterface, Runnable {
    ArrayList<BeatObserver> beatObservers = new ArrayList<BeatObserver>();
    ArrayList<BPMObserver> bpmObservers = new ArrayList<BPMObserver>();
    int bpm = 90;
    int time = 1000;
    Random random = new Random(System.currentTimeMillis());
    Thread thread;

    public static void main(String[] args) {
        HeartModel app = new HeartModel();
    }

    public HeartModel() {
        thread = new Thread(this);
        thread.start();
    }

    public void run() {
        int lastrate = -1;

        for(;;) {
            int change = random.nextInt(10);
            if (random.nextInt(2) == 0) {
                change = 0 - change;
            }
            int rate = 60000/(time + change);

            if (rate < 120 && rate > 50) {
                time += change;
                notifyBeatObservers();
                System.out.println("beat: " + getHeartRate());
                if (rate != lastrate) {
                    lastrate = rate;
                    notifyBPMObservers();
                    System.out.println("bpm: " + getHeartRate());
                }
            }
            try {
                Thread.sleep(time);
            } catch (Exception ex) { ex.printStackTrace(); }
        }
    }

    public int getHeartRate() {
        return 60000/time;
    }

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
}
