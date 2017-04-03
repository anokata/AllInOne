import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.swing.*;
import javax.swing.Timer;
 
public class ShapesDemo2D extends JApplet implements ActionListener {
    final static Color bg = Color.white;
    final static Color fg = Color.black;
    final static Color red = Color.red;
    final static Color white = Color.white;
    final static BasicStroke stroke = new BasicStroke(2.0f);
    final static BasicStroke wideStroke = new BasicStroke(8.0f);
    final static float dash1[] = {10.0f};
    static int X = 0;
    static Timer timer;
    static ActionListener update;
    Image buffer;

    public void init() {
        setBackground(bg);
        setForeground(fg);
    }
 
    public void actionPerformed(ActionEvent e) {
        repaint();
    }

    public void paint(Graphics g) {
        super.paint(g);
        buffer = new BufferedImage(getWidth(), getHeight(),
              BufferedImage.TYPE_INT_RGB);
        Graphics2D g3 = (Graphics2D) g;
        Graphics2D g2 = (Graphics2D) buffer.getGraphics();
        //g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        //Color fg3D = Color.lightGray;
 
        //g2.setPaint(fg3D);
        //g2.draw3DRect(0, 0, d.width - 1, d.height - 1, true);
        //g2.draw3DRect(3, 3, d.width - 7, d.height - 7, false);
        //g2.setPaint(fg);
        //g2.fill(new Rectangle2D.Double(0, 0, 100, 100));
        /*
        int x = 50 + X;
        int y = 70;
        X++;
 
        g2.drawString("Line2D", x, y);
        g2.draw(new Line2D.Double(x, y+20, x + 20, y));
        //g2.setStroke(stroke);
        g2.draw(new Rectangle2D.Double(x, y, 30, 30));

        x += 30; 
        y += 30; 
        g2.draw(new Arc2D.Double(x, y, 30, 30, 90, 360, Arc2D.OPEN));
        x += 30; 
        y += 30; 
        //g2.setPaint(red);
        g2.fill(new Rectangle2D.Double(x, y, 30, 30));
        x += 30; 
        y += 30; 
        g2.draw(new Ellipse2D.Double(x, y, 30, 30));
        */

        g3.drawImage(buffer, 0, 0, this);
    }

    public ShapesDemo2D() {
        timer = new Timer(20, this);
        timer.setInitialDelay(190);
        timer.start();
    }
 
    public static void main(String s[]) {
        JFrame f = new JFrame("ShapesDemo2D");
        f.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {System.exit(0);}
        });
        JApplet applet = new ShapesDemo2D();
        f.getContentPane().add("Center", applet);
        applet.init();
        f.pack();
        f.setSize(new Dimension(550,100));
        f.setVisible(true);
        f.add(new ShapesDemo2D());

    }
 
}
