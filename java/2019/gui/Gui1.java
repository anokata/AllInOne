import javax.swing.*;
import java.awt.event.*;

public class Gui1 implements ActionListener {
    JButton button;
    JFrame frame;

    public static void main(String[] args) {
        Gui1 g = new Gui1();
    }

    Gui1() {
        frame = new JFrame();
        button = new JButton("click me");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().add(button);
        frame.setSize(300,300);
        frame.setVisible(true);
        button.addActionListener(this);
    }

    public void actionPerformed(ActionEvent e) {
        button.setText("clicked");
    }
}
