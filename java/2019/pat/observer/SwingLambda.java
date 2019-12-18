import java.awt.event.*;
import javax.swing.*;
import java.awt.*;
import java.util.*;

class SwingLambda {
    public static void main(String[] args) {
        SwingLambda app = new SwingLambda();
    }

    SwingLambda () {
        JFrame frame = new JFrame();
        JButton b = new JButton("CLackME");
        frame.getContentPane().add(b);
        b.addActionListener(event -> b.setText("clicked"));
        b.addActionListener(e -> System.out.println("hi"));

        frame.setVisible(true);
    }
}

