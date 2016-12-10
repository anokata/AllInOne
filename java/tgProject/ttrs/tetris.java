//java2d
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;

// главный класс. просто создаёт форму.
public class tetris {
	public static void main(String args[]) {
		new MainFrame().setVisible(true);
	}
}
// главная форма-фрейм.
class MainFrame extends JFrame {
	JLabel lab1;
	
	public MainFrame() {
		super();
		// главная панель с компнентами.
		JPanel mainPanel = new JPanel(new BorderLayout(0, 0));
		setContentPane(mainPanel);
		// панель для тетриса.
		JPanel tetrisPanel = new JPanel();
		mainPanel.add(tetrisPanel, BorderLayout.WEST);
		// надпись.
		lab1 = new JLabel("LT|ZSO", SwingConstants.CENTER);
		lab1.setPreferredSize(new Dimension(30,30));
		lab1.setBorder(BorderFactory.createLineBorder(new Color(30, 100, 130), 2));
		mainPanel.add(lab1, BorderLayout.NORTH);
		// создание класса компонента отображющего состояние.
		TetrisPainter t = new TetrisPainter();
		t.setPreferredSize(new Dimension(100, 100));
		//t.setBorder(BorderFactory.createLineBorder(new Color(100,200,100), 2));
		tetrisPanel.add(t);
		// добавление обработчика события.
		ActionMap am = mainPanel.getActionMap();
		am.put("onLeft", new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
				System.out.print("L");
            }
        });
		
		mainPanel.getInputMap().put(KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_LEFT, 0, false), "onLeft");
		
		mainPanel.setBackground(new Color(235, 234, 230));
		setSize(500,400);
		setLocationRelativeTo(null);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		
		// создание объекта логики игры.
		tetrisGameFieldNLogic tgf = new tetrisGameFieldNLogic();
		// связывание рендера состояния и логики.
		t.setTet(tgf);
		
	}
}
// класс игровой логики.
class tetrisGameFieldNLogic {
	public int field[][];
	public final int WIDTH = 5;
	public final int HEIGHT = 10;
	
	tetrisGameFieldNLogic() {
		field = new int[WIDTH][HEIGHT];
		int i,j;
		for (i=0;i<WIDTH;i++)
		for (j=0;j<HEIGHT;j++)
		field[i][j] = 0;
		
		field[1][2] = 1;
		field[2][2] = 2;
		field[3][2] = 3;
		field[1][3] = 4;
	}
}
// класс ренедера.
class TetrisPainter extends Component {
	tetrisGameFieldNLogic t;
	final int WH = 20;
	Color colors[];
	
	TetrisPainter() {
		this.colors = new Color[4];
		int x = 150;
		int y = 230;
		this.colors[0] = new Color(y, x, x);
		this.colors[1] = new Color(x, y, x);
		this.colors[2] = new Color(x, x, y);
		this.colors[3] = new Color(y, x, y);
	}
	
	public void setTet(tetrisGameFieldNLogic t) {
		this.t = t;
	}
	
	public void paint(Graphics g) {
		Graphics2D g2 = (Graphics2D) g;
		g.setColor(Color.BLUE);
		g2.fillRect(20,20,20,20);
		if (t != null) tetPainter_1(g2);
	}
	void tetPainter_1(Graphics2D g) {
		int i,j;
		for (i=0;i<t.WIDTH;i++)
		for (j=0;j<t.HEIGHT;j++)
			if (t.field[i][j] != 0) {
				g.setColor(colors[t.field[i][j] - 1]);
				g.fillRect(WH * i, WH * j, WH, WH);
			}
				
		
	}

}


