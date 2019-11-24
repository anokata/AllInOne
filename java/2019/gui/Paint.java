import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Paint implements ActionListener {
    JButton button;
    JButton labelButton;
    JFrame frame;
    Canvas c;

    public static void main(String[] args) {
        Paint p = new Paint();
    }

    Paint() {
        c = new Canvas();
        frame = new JFrame();
        button = new JButton("change color");
        labelButton = new JButton("change label");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().add(BorderLayout.CENTER, c);
        frame.getContentPane().add(BorderLayout.SOUTH, button);
        frame.getContentPane().add(BorderLayout.NORTH, labelButton);
        frame.setSize(300,300);
        frame.setVisible(true);
        button.addActionListener(this);
        LabelButtonAction labelButtonAction = new LabelButtonAction();
        labelButton.addActionListener(labelButtonAction);
    }
   
    public void actionPerformed(ActionEvent e) {
        c.c1 = Color.orange;
        frame.repaint();
    }

    // внутренний класс
    class LabelButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            labelButton.setText("Hello!");
        }
    }
}

class Canvas extends JPanel {
    Image img;
    Color c1 = Color.RED;

    Canvas() {
        img = new ImageIcon("/mnt/store/books/read/now/draw/Boku.no.Hero.Academia.full.2126177.jpg").getImage();
    }

    public void paintComponent(Graphics g) {
        g.fillRect(0,0,this.getWidth(), this.getHeight());
        //g.drawImage(img, 0, 0, this);
        g.setColor(c1);
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

