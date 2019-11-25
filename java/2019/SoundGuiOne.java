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
    Sequencer s; 

    public void go() {
        s = playerInit();
        guiInit();
        start();
    }
    
    public void start() {
        s.start();
        while (s.isRunning()) {
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace(); 
            }
        }
    }

    public void guiInit() {
        canva = new DrawPanel();
        frame.setContentPane(canva);
        frame.setBounds(30,30, 300,300);
        frame.setVisible(true);
    }
    
    public Sequencer playerInit() {
        try {
            final Sequencer sequencer = MidiSystem.getSequencer();
            sequencer.open();

            sequencer.addControllerEventListener(canva, new int[] {127});

            Sequence seq = new Sequence(Sequence.PPQ, 4);

            Track track = seq.createTrack();

            int r = 0;
            for (int i = 15; i < 41; i+= 4) {

                r = (int) ((Math.random() * 50) + 1);
                track.add(makeEvent(144, 1, r, 100, i));
                track.add(makeEvent(176, 1, 127, 0, i)); // ControllerEvent 
                track.add(makeEvent(128, 1, r, 100, i + 2));
            }

            sequencer.setSequence(seq);
            sequencer.setTempoInBPM(220);

            sequencer.addMetaEventListener( new MetaEventListener() {
              public void meta(MetaMessage metaMsg) {
                if (metaMsg.getType() == 47)
                  sequencer.close(); 
                }
            });
            return sequencer;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
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
        //if (!msg) return;
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

