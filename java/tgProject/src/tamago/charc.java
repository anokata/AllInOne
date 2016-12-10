package tamago;

import javax.swing.*;
import java.awt.*;

public class charc extends JPanel {

    public charc() {
        setOpaque(false);
    }
    
    private void drawChar(Graphics2D g) {
        g.setColor(Color.black);
        g.fillRect(10,10,200,200);
        g.setStroke(new BasicStroke(10, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        g.drawArc(getWidth()/4, getHeight()/4, getWidth()/2, getHeight()/2, 225, 90);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D)g;
        g2d.setClip(getWidth() / 4, getWidth() / 4, getWidth() / 2, getHeight() / 2);
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        drawChar(g2d);
        //g2d.setColor(Color.black);
        //g2d.fillRect(10,10,200,200);
        //g2d.fillOval(10, 10, getWidth() - 20, getHeight() * 2 - 20);
        //g2d.fillOval(20, 20, getWidth() - 40, getHeight() - 40);
        //g2d.fillOval(30, 30, getWidth() - 60, getHeight() - 60);
        //g2d.setColor(Color.black);
        //g2d.fillOval(getWidth()/4 - getWidth()/16, getHeight()/2-getHeight()/8, getWidth()/8, getHeight()/8);
        //g2d.fillOval(getWidth()*3/4 - getWidth()/16, getHeight()/2-getHeight()/8, getWidth()/8, getHeight()/8);
        //g2d.setStroke(new BasicStroke(10, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        //g2d.drawArc(getWidth()/4, getHeight()/4, getWidth()/2, getHeight()/2, 225, 90);
    }
}
//24m 11p 11m 12m 13p 14m 7m 8p 1p 2m 3m 