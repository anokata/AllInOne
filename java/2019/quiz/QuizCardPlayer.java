import java.awt.event.*;
import javax.swing.*;
import java.util.*;
import java.awt.*;
import java.io.*;

// pg 478
class QuizCardPlayer {
    public static void main(String[] args) {
        System.out.println("QuizCardPlayer");
        QuizCardPlayer app = new QuizCardPlayer();
        app.go();
    }

    JFrame frame;

    public void go() {
        frame = new JFrame();
        JPanel mainPanel = new JPanel();




        frame.getContentPane().add(mainPanel);
        mainPanel.setBackground(Color.darkGray);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
    }

    class NextCardListener implements ActionListener {
        public void actionPerformed(ActionEvent e) {
        }
    }

    class OpenMenuListener implements ActionListener {
        public void actionPerformed(ActionEvent e) {
        }
    }

    private void loadFile(File file) {
    }

    private void makeCard(String lineToParse) {
    }

}

