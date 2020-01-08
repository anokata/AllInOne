import java.awt.event.*;
import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.io.*;
import java.net.*;

interface ImageProxyState {
    public int getIconWidth();
    public int getIconHeight();
    public void paintIcon(final Component c, Graphics g, int x, int y);
}

class LoadingState implements ImageProxyState {
    ImageProxy imageProxy;

    LoadingState(ImageProxy p) {
        imageProxy = p;
    }

    public int getIconWidth() {
        return 800;
    }

    public int getIconHeight() {
        return 600;
    }

    public void paintIcon(final Component c, Graphics g, int x, int y) {
        g.drawString("Loading CD cover, please wait...", x+300, y+190);
        if (!imageProxy.retrieving) {
            imageProxy.retrieving = true;
            imageProxy.retrievalThread = new Thread(new Runnable() {
                public void run() {
                    try {
                        imageProxy.setIconImage(new ImageIcon(imageProxy.imageURL, "CD Cover"));
                        c.repaint();
                    } catch (Exception ex) { ex.printStackTrace(); }
                }
            });
            imageProxy.retrievalThread.start();
        }
    }
}

class IconState implements ImageProxyState {
    ImageProxy imageProxy;

    IconState(ImageProxy p) {
        imageProxy = p;
    }

    public int getIconWidth() {
        return imageProxy.imageIcon.getIconWidth();
    }

    public int getIconHeight() {
        return imageProxy.imageIcon.getIconHeight();
    }

    public void paintIcon(final Component c, Graphics g, int x, int y) {
        imageProxy.imageIcon.paintIcon(c, g, x, y);
    }
}

class ImageProxy implements Icon {
    volatile ImageIcon imageIcon;
    final URL imageURL;
    Thread retrievalThread;
    boolean retrieving = false;
    ImageProxyState state;
    ImageProxyState loadingState;
    ImageProxyState iconState;

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
        this.loadingState = new LoadingState(this);
        this.iconState = new IconState(this);
        this.state = loadingState;
    }

    public int getIconWidth() {
        return state.getIconHeight();
    }

    public int getIconHeight() {
        return state.getIconWidth();
    }
    
    synchronized void setIconImage(ImageIcon icon) {
        this.imageIcon = icon;
        this.state = this.iconState;
    }

    public void paintIcon(final Component c, Graphics g, int x, int y) {
        state.paintIcon(c,g,x,y);
    }
}

