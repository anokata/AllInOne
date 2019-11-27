import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.sound.midi.*;
import java.util.*;

class BeatBox {
    public static void main(String[] args) {
        BeatBox app = new BeatBox();
        app.go();
    }

    JFrame frame;
    ArrayList<JCheckBox> checkBoxList;
    final String[] instrumentNames = {
        "Bass Drum", "Closed Hi-Hat", "Open Hi-Hat",
        "Acoustic Snare",
        "Crash Cymbal",
        "Hand Clap",
        "High Tom",
        "Hi Bongo",
        "Maracas",
        "Whistle",
        "Low Conga",
        "Cowbell",
        "Vibraslap",
        "Low-mid Tom",
        "High Agogo",
        "Open Hi Conga",
    };
    final int[] instruments = {35,42,46,38,49,39,50,60,70,72,64,56,58,47,67,63};

    Sequencer sequencer;
    Sequence sequence;
    Track track;

    public void go() {
        frame = new JFrame();
        checkBoxList = new ArrayList<JCheckBox>();
        JPanel labelPanel = new JPanel();
        JPanel boxPanel = new JPanel();
        JPanel buttonPanel = new JPanel();
        GridLayout gridLabel = new GridLayout(16, 1);

        frame.getContentPane().add(BorderLayout.WEST, labelPanel);
        frame.getContentPane().add(BorderLayout.CENTER, boxPanel);
        frame.getContentPane().add(BorderLayout.EAST, buttonPanel);
        javax.swing.border.Border border = BorderFactory.createEmptyBorder(10,10,10,10);
        labelPanel.setBorder(border);
        boxPanel.setBorder(border);
        buttonPanel.setBorder(border);

        JButton startButton = new JButton("Start");
        JButton stopButton = new JButton("Stop");
        JButton tempUp = new JButton("Tempo Up");
        JButton tempDown= new JButton("Tempo Down");
        JButton exitButton = new JButton("exit");
        JButton clearButton = new JButton("clear");
        JButton randomButton = new JButton("randomize");

        buttonPanel.setLayout(new BoxLayout(buttonPanel, BoxLayout.Y_AXIS));
        gridLabel.setVgap(1);
        labelPanel.setLayout(gridLabel);

        buttonPanel.add(startButton);
        buttonPanel.add(stopButton);
        buttonPanel.add(tempUp);
        buttonPanel.add(tempDown);
        buttonPanel.add(randomButton);
        buttonPanel.add(clearButton);
        buttonPanel.add(exitButton);
        startButton.addActionListener(new StartButtonAction());
        stopButton.addActionListener(new StopButtonAction());
        exitButton.addActionListener(new ExitButtonAction());
        tempUp.addActionListener(new TempUpButtonAction());
        tempDown.addActionListener(new TempDownButtonAction());
        clearButton.addActionListener(new ClearButtonAction());
        randomButton.addActionListener(new RandomButtonAction());

        for (String labelName : instrumentNames) {
            JLabel label = new JLabel(labelName);
            labelPanel.add(label);
        }

        GridLayout grid = new GridLayout(16, 16);
        grid.setVgap(1);
        grid.setHgap(1);
        boxPanel.setLayout(grid);
        for (int i=0; i < 256; i++) {
            JCheckBox c = new JCheckBox();
            c.setSelected(((int) (Math.random() * 2) == 1));
            checkBoxList.add(c);
            boxPanel.add(c);
        }

        setUpMidi();

        frame.setSize(500, 600);
        frame.pack();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
    }

    void setUpMidi() {
        try {
            sequencer = MidiSystem.getSequencer();
            sequencer.open();
            sequence = new Sequence(Sequence.PPQ, 4);
            track = sequence.createTrack();
            sequencer.setTempoInBPM(120);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void buildTrackAndStart() {
        int[] trackList = null;

        sequence.deleteTrack(track);
        track = sequence.createTrack();

        for (int i=0; i < 16; i++) {
            trackList = new int[16];
            int key = instruments[i];
            for (int j=0; j < 16; j++) {
                JCheckBox jc = (JCheckBox) checkBoxList.get(j + i*16);
                if (jc.isSelected()) {
                    trackList[j] = key;
                } else {
                    trackList[j] = 0;
                }
            }

            makeTracks(trackList);
            track.add(makeEvent(176, 1, 127, 0, 16));
        }

        track.add(makeEvent(192, 9, 1, 0, 15));
        try {
            sequencer.setSequence(sequence);
            sequencer.setLoopCount(sequencer.LOOP_CONTINUOUSLY);
            sequencer.start();
            System.out.println("started");
            sequencer.setTempoInBPM(120);
        } catch (Exception e) {e.printStackTrace();}
    }

    class StartButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            buildTrackAndStart();
        }
    }

    class ExitButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            sequencer.stop();
            sequencer.close();
            frame.dispose();
        }
    }

    class StopButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            sequencer.stop();
        }
    }

    class RandomButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
        for (JCheckBox c : checkBoxList) {
            c.setSelected(((int) (Math.random() * 2) == 1));
        }

        }
    }

    class ClearButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            sequencer.stop();
            for (JCheckBox c : checkBoxList) {
                c.setSelected(false);
            }
        }
    }

    class TempUpButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            float tempoFactor = sequencer.getTempoFactor();
            sequencer.setTempoFactor((float)(tempoFactor * 1.03));
        }
    }

    class TempDownButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            float tempoFactor = sequencer.getTempoFactor();
            sequencer.setTempoFactor((float)(tempoFactor * 0.97));
        }
    }

    public MidiEvent makeEvent(int comd, int chan, int one, int two, int tick) {
        MidiEvent event = null;
        try {
            ShortMessage a = new ShortMessage();
            a.setMessage(comd, chan, one, two);
            event = new MidiEvent(a, tick);
        } catch (Exception e) {e.printStackTrace();}
        return event;
    }

    public void makeTracks(int[] list) {
        for (int i=0; i < list.length; i++) {
            int key = list[i];
            if (key != 0) {
                track.add(makeEvent(144,9,key, 100,i));
                track.add(makeEvent(128,9,key, 100,i+1));
            }
        }
    }


}
