//java2d, keyboard
import javax.swing.*;
import java.awt.*;


public class tetris {
	public static void main(String args[]) {
		new MainFrame().setVisible(true);
	}
}

class MainFrame extends JFrame {
	JLabel lab1;
	
	public MainFrame() {
		super();
		
		JPanel mainPanel = new JPanel(new BorderLayout(0, 0));
		setContentPane(mainPanel);
		
		lab1 = new JLabel("LT|ZSO", SwingConstants.CENTER);
		lab1.setPreferredSize(new Dimension(30,30));
		lab1.setBorder(BorderFactory.createLineBorder(new Color(30, 100, 130), 2));
		mainPanel.add(lab1);
		
		mainPanel.setBackground(new Color(235, 234, 230));
		setSize(500,400);
		setLocationRelativeTo(null);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		
		
	}
}