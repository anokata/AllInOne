import javax.sound.midi.*;
import javax.swing.*;
import java.awt.*;
import java.io.*;

class SoundGuiOne {
    public static void main(String[] args) {
        (new SoundGuiOne()).go();
    }
    
    static JFrame frame = new JFrame("Music random player");
    static DrawPanel canva;

    public void go() {
        Sequencer s = playerInit();
        guiInit();
        s.start();
        //s.close();
    }

    public void guiInit() {
        canva = new DrawPanel();
        frame.setContentPane(canva);
        frame.setBounds(30,30, 300,300);
        frame.setVisible(true);
    }
    
    public Sequencer playerInit() {
        Sequencer sequencer = null;
        try {
            sequencer = MidiSystem.getSequencer();
            sequencer.open();

            int[] eventsIWant = {127};
            sequencer.addControllerEventListener(canva, eventsIWant);

            Sequence seq = new Sequence(Sequence.PPQ, 4);
            Track track = seq.createTrack();

            for (int i = 15; i < 71; i+= 4) {
                track.add(makeEvent(144, 1, i, 100, i));
                track.add(makeEvent(176, 1, 127, 0, i)); // ControllerEvent 
                track.add(makeEvent(128, 1, i, 100, i + 2));
            }

            sequencer.setSequence(seq);
            sequencer.setTempoInBPM(220);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return sequencer;
    }

    public static MidiEvent makeEvent(int comd, int chan, int one, int two, int tick) {
        MidiEvent event = null;
        try {
            ShortMessage s = new ShortMessage();
            s.setMessage(comd, chan, one, two);
            event = new MidiEvent(s, tick);
        } catch (Exception e) {
        }
        return event;
    }

class DrawPanel extends JPanel implements ControllerEventListener {
    boolean msg = false;

    public void controlChange(ShortMessage event) {
        System.out.println("la");
        msg = true;
        repaint();
    }

    public void paintComponent(Graphics g) {
        if (!msg) return;

        Graphics2D g2 = (Graphics2D) g;
        int red = (int) (Math.random() * 250);
        int gre = (int) (Math.random() * 250);
        int blu = (int) (Math.random() * 250);

        g.setColor(new Color(red, gre, blu));
        int height = (int) (Math.random() * 120) + 10;
        int width = (int) (Math.random() * 120) + 10;
        int x = (int) (Math.random() * 40) + 10;
        int y = (int) (Math.random() * 40) + 10;
        g.fillRect(x, y, height, width);
        msg = false;
    }
}
}

