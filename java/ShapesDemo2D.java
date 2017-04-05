import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.swing.*;
import java.util.Timer;
import java.util.TimerTask;
 
public class ShapesDemo2D extends JFrame {
    final static Color bg = Color.white;
    final static Color fg = Color.black;
    final static Color red = Color.red;
    final static Color white = Color.white;
    final static BasicStroke stroke = new BasicStroke(2.0f);
    final static BasicStroke wideStroke = new BasicStroke(8.0f);
    Image buffer;
    Dimension oldSize;
    Render render;

    public ShapesDemo2D() {
        render = new Render();
    }

    public void paint(Graphics g) {
        if ((oldSize == null) || (oldSize != getSize())) {
            oldSize = getSize();
            buffer = new BufferedImage(getWidth(), getHeight(),
                  BufferedImage.TYPE_INT_RGB);
        }
        Graphics2D g2 = (Graphics2D) buffer.getGraphics();
        g2.setColor(Color.BLACK);
        g2.fillRect(0, 0, getWidth(), getHeight());
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        render.rend(g2);
        g.drawImage(buffer, 0, 0, this);
    }

    public void go() {
        TimerTask task = new TimerTask() {
            public void run() {
                repaint();
            }
        };
        Timer timer = new Timer();
        timer.schedule(task, 0, 100);
    }
 
    public static void main(String s[]) {
        ShapesDemo2D f = new ShapesDemo2D();
        f.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {System.exit(0);}
        });
        f.setSize(new Dimension(550,500));
        f.show();
        f.go();
    }
 
}

class Render {
    int X = 100;

    public void rend(Graphics2D g) {
        g.setPaint(Color.blue);
        g.fill(new Rectangle2D.Double(0, 0, 100, 100));
        int x = 50 + X;
        int y = 70;
        X++;
 
        g.drawString("Line2D", x, y);
        g.draw(new Line2D.Double(x, y+20, x + 20, y));
        //g.setStroke(stroke);
        g.draw(new Rectangle2D.Double(x, y, 30, 30));

        x += 30; 
        y += 30; 
        g.draw(new Arc2D.Double(x, y, 30, 30, 90, 360, Arc2D.OPEN));
        x += 30; 
        y += 30; 
        g.fill(new Rectangle2D.Double(x, y, 30, 30));
        x += 30; 
        y += 30; 
        g.draw(new Ellipse2D.Double(x, y, 30, 30));
    }
}
