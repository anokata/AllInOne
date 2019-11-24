import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class AnimateOne {
    public static void main(String[] args) {
        new AnimateOne();
    }

    int x = 300;
    int y = 300;

    AnimateOne() {
        JFrame frame = new JFrame();
        frame.setSize(300,300);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
        frame.getContentPane().add(BorderLayout.CENTER, new AnimPanel());
        for (int i = 0; i < 300; i++) {
            x--;
            y--;
            frame.repaint();
            try {
                Thread.sleep(50);
            } catch (Exception ex) {}
        }
    }

    class AnimPanel extends JPanel {
        public void paintComponent(Graphics g) {
            g.fillRect(0,0,this.getWidth(), this.getHeight());
            g.setColor(Color.BLUE);
            g.fillOval(x, y, 20, 20);
        }
    }
}
