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

    static Hashtable<String, String> cds = new Hashtable<String, String>();
    public static void main(String[] args) throws Exception {
        // Test
        ImageComponent imageComponent;
        JFrame frame = new JFrame("CD Cover Viewer");
        JMenuBar menuBar;
        JMenu menu;
		cds.put("Buddha Bar","http://images.amazon.com/images/P/B00009XBYK.01.LZZZZZZZ.jpg");
		cds.put("Ima","http://images.amazon.com/images/P/B000005IRM.01.LZZZZZZZ.jpg");
		cds.put("Karma","http://images.amazon.com/images/P/B000005DCB.01.LZZZZZZZ.gif");
		cds.put("MCMXC A.D.","http://images.amazon.com/images/P/B000002URV.01.LZZZZZZZ.jpg");
		cds.put("Northern Exposure","http://images.amazon.com/images/P/B000003SFN.01.LZZZZZZZ.jpg");
		cds.put("Selected Ambient Works, Vol. 2","http://images.amazon.com/images/P/B000002MNZ.01.LZZZZZZZ.jpg");

		URL initialURL = new URL((String)cds.get("Selected Ambient Works, Vol. 2"));
		menuBar = new JMenuBar();
		menu = new JMenu("Favorite CDs");
		menuBar.add(menu);
		frame.setJMenuBar(menuBar);
        
		Icon icon = new ImageProxy(initialURL);
		imageComponent = new ImageComponent(icon);

		for (Enumeration<String> e = cds.keys(); e.hasMoreElements();) {
			String name = (String)e.nextElement();
			JMenuItem menuItem = new JMenuItem(name);
			menu.add(menuItem); 
			menuItem.addActionListener(event -> {
				imageComponent.setIcon(new ImageProxy(getCDUrl(event.getActionCommand())));
				frame.repaint();
			});
		}

		frame.getContentPane().add(imageComponent);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(800,600);
		frame.setVisible(true);
    }

	static URL getCDUrl(String name) {
		try {
			return new URL((String)cds.get(name));
		} catch (MalformedURLException e) {
			e.printStackTrace();
			return null;
		}
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

