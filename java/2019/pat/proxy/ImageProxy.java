import java.awt.event.*;
import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.io.*;
import java.net.*;

// TODO To State
class ImageProxy implements Icon {
    volatile ImageIcon imageIcon;
    final URL imageURL;
    Thread retrievalThread;
    boolean retrieving = false;

    public static void main(String[] args) throws Exception {
        // Test
        URL url = ; // TODO
        ImageComponent image;
        Icon icon = new ImageProxy(url);
        image = new ImageComponent(icon);
        frame.getContentPane().add(image);
    }

    ImageProxy (URL url) {
        this.imageURL = url;
        System.out.println("Created ImageProxy");
    }

    public int getIconWidth() {
        if (imageIcon != null) {
            return imageIcon.getIconWidth();
        } else {
            return 800;
        }
    }

    public int getIconHeight() {
        if (imageIcon != null) {
            return imageIcon.getIconHeight();
        } else {
            return 600;
        }
    }
    
    synchronized void setIconImage(ImageIcon icon) {
        this.imageIcon = icon;
    }

    public void paintIcon(final Component c, Graphics g, int x, int y) {
        if (imageIcon != null) {
            imageIcon.paintIcon(c, g, x, y);
        } else {
            g.drawString("Loading CD cover, please wait...", x+300, y+190);
            if (!retrieving) {
                retrieving = true;
                retrievalThread = new Thread(new Runnable() {
                    public void run() {
                        try {
                            setIconImage(new ImageIcon(imageURL, "CD Cover"));
                            c.repaint();
                        } catch (Exception ex) { ex.printStackTrace(); }
                    }
                });
                retrievalThread.start();
            }
        }
    }



}

