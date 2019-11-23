import javax.swing.*;
import java.awt.*;

public class Paint {
    public static void main(String[] args) {
        Canvas c = new Canvas();
        JFrame frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().add(c);
        frame.setSize(300,300);
        frame.setVisible(true);
    }
}

class Canvas extends JPanel {
    Image img;

    Canvas() {
        img = new ImageIcon("/mnt/store/books/read/now/draw/Boku.no.Hero.Academia.full.2126177.jpg").getImage();
    }

    public void paintComponent(Graphics g) {
        g.fillRect(0,0,this.getWidth(), this.getHeight());
        //g.drawImage(img, 0, 0, this);
        g.setColor(Color.orange);
        g.fillRect(20,30,100,100);
        g.fillOval(70,70,100,100);
        if (g instanceof Graphics2D) {
            Graphics2D gd = (Graphics2D) g;
            GradientPaint gradient = new GradientPaint(70, 70, Color.blue, 150,150, Color.orange);
            gd.setPaint(gradient);
            gd.fill3DRect(20, 20, 200, 200,true);
            g.fillOval(70,70,100,100);
        }
    }
}

