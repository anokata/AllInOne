import javax.swing.*;
import java.awt.event.*;
import java.awt.*;

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
        button.addActionListener(this);

        JButton anobut = new JButton("anon button");
        frame.getContentPane().add(BorderLayout.EAST, anobut);
        anobut.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev) {
                System.out.println("Anonimous Class in Action!");
            }
        });

        frame.setSize(300,300);
        frame.setVisible(true);
    }

    public void actionPerformed(ActionEvent e) {
        button.setText("clicked");
    }
}
