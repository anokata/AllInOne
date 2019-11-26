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
        "",
        "",
        "",
        "",
        "",
    };
    final int[] instruments = {35,42};

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

        buttonPanel.setLayout(new BoxLayout(buttonPanel, BoxLayout.Y_AXIS));
        gridLabel.setVgap(1);
        labelPanel.setLayout(gridLabel);

        buttonPanel.add(startButton);
        buttonPanel.add(stopButton);
        buttonPanel.add(tempUp);
        buttonPanel.add(tempDown);
        buttonPanel.add(exitButton);
        startButton.addActionListener(new StartButtonAction());
        stopButton.addActionListener(new StopButtonAction());
        exitButton.addActionListener(new ExitButtonAction());
        tempUp.addActionListener(new TempUpButtonAction());
        tempDown.addActionListener(new TempDownButtonAction());

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

    class StartButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            System.out.println("tst");
        }
    }

    class ExitButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            sequencer.close();
            frame.dispose();
        }
    }

    class StopButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
        }
    }

    class TempUpButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
        }
    }

    class TempDownButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
        }
    }

    public MidiEvent makeEvent(int comd, int chan, int one, int two, int tick) {
        MidiEvent event = null;
        try {
        } catch (Exception e) {e.printStackTrace()};
        return event;
    }
}
