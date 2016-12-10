package tamago;

import tamago.charc;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import tamago.gocha;
import javax.swing.Timer;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

// температура, окружение, перемещение
// развитие
// болезни лечение, туалет санитария, сон, работа
// вещи. карьера. общение. желания. дом, предметы. где находится.
// перемещение, места.
// переделать на проценты многое.
// телосложени, жир, мышцы, занятия.
// графики
public class tamagoMain extends JFrame {

    public gocha g;
    //private MyTimerTask mMyTimerTask;
    protected Timer mTimer;
    public JLabel labAge;
    public JLabel labAgeVal;
    public JLabel labHealthVal;
    JLabel labState;
    public JProgressBar progressBarHealth;
    // joy
    JLabel labJoy;
    JLabel labJoyVal;
    JProgressBar progressBarJoy;
    // fullness
    JLabel labfullness;
    JLabel labfullnessVal;   
    JLabel labAvailableFood;
    JProgressBar progressBarfullness;
    
    JSlider speedSlider;
    
    JLabel statusLabs[];
    
    public static tamagoMain self;
    final int border1 = 2;
    
    public void step() {
      g.lifeStep();
      //labAgeVal.setText(Long.valueOf(g.getAge()).toString());
      labAgeVal.setText(g.getAgeF());
      labHealthVal.setText(Integer.valueOf(g.getHealth()).toString());
      progressBarHealth.setValue(g.getHealth());
      labState.setText(g.getState());

      // joy
      labJoyVal.setText(Long.valueOf(g.getJoy()).toString());
      progressBarJoy.setValue(g.getJoy());      
      // fullness
      labfullnessVal.setText(Long.valueOf(g.getfullness()).toString());
      labAvailableFood.setText("Еда: " + Long.valueOf(g.getavailableFood()).toString());
      progressBarfullness.setValue(g.getfullness());  
      
    }
    
    private JLabel createStatusLabel(int n, JPanel cp, String initText, int w) {
        statusLabs[n] = new JLabel(initText, SwingConstants.CENTER);
        statusLabs[n].setPreferredSize(new Dimension(w*70, 20));
        statusLabs[n].setBorder(BorderFactory.createLineBorder(new Color(0x0080F0), 2));
        cp.add(statusLabs[n], new GridBagConstraints(n % 2, n / 2, w, 1, 0.1, 0.01,
            GridBagConstraints.NORTH, GridBagConstraints.HORIZONTAL, new Insets(5, 5, 0, 5), 0, 0));
        return statusLabs[n];
    }
    
    private void createStatusComps(JPanel cp) {
		int w = 1;
		statusLabs = new JLabel[9];
		createStatusLabel(0, cp, "Str: 1", w);
		createStatusLabel(1, cp, "Con: 1", w);
		createStatusLabel(2, cp, "Agi: 1", w);
		createStatusLabel(3, cp, "Int: 1", w);
		createStatusLabel(4, cp, "Luk: 1", w);
		createStatusLabel(5, cp, "Wil: 1", w);
		createStatusLabel(6, cp, "LVL: 1", w);
		createStatusLabel(7, cp, "SP: 0", w);
		createStatusLabel(8, cp, "EXP: 0", 2);
		
		JButton btn = new JButton("-");
        btn.addActionListener(new ActionListener(){
            public void actionPerformed(ActionEvent e) {
                
            }
        });
        cp.add(btn, new GridBagConstraints(0, 9, 2, 1, 1, 0.99, GridBagConstraints.SOUTH,
            GridBagConstraints.HORIZONTAL, new Insets(0, 0, 0, 0), 0, 0));
    }
    
    public tamagoMain() {
        super("test");
        
        JPanel mainPanel = new JPanel(new BorderLayout(0, 0));
        
        
        JPanel cp = new JPanel(new GridBagLayout());
        cp.setBorder(BorderFactory.createCompoundBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5),
                BorderFactory.createLineBorder(Color.black)));
        mainPanel.add(cp, BorderLayout.WEST);
        
        JPanel statusPanel = new JPanel(new GridBagLayout());
        statusPanel.setBorder(BorderFactory.createCompoundBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5),
                BorderFactory.createLineBorder(Color.black)));
        mainPanel.add(statusPanel, BorderLayout.EAST);
        
        setContentPane(mainPanel);
        
        g = new gocha();
        
        mTimer = new Timer(500, new ActionListener() {
            public void actionPerformed(ActionEvent  event) {
                step();
            }
        });
        mTimer.setInitialDelay(500);
        
        Color bcolor = new Color(0xff8000);
        Dimension d1 = new Dimension(80, 30);
        Dimension d2 = new Dimension(50, 30);
        Dimension d3 = new Dimension(150, 30);
        int gridY = 0;
        
        // Health
        JLabel labHealth = new JLabel("Здоровье: ", SwingConstants.CENTER);
        labHealth.setPreferredSize(d1);
        labHealth.setBorder(BorderFactory.createLineBorder(bcolor, border1));
        cp.add(labHealth, new GridBagConstraints(0, gridY, 1, 1, 0.3, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 0), 0, 0));
            
        labHealthVal = new JLabel(Integer.valueOf(g.getHealth()).toString(), SwingConstants.CENTER);
        labHealthVal.setPreferredSize(d2);
        labHealthVal.setBorder(BorderFactory.createLineBorder(bcolor, border1));
        cp.add(labHealthVal, new GridBagConstraints(4, gridY, 1, 1, 0.1, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 10), 0, 0));

        progressBarHealth = new JProgressBar(0, g.MAX_HEALTH);
        progressBarHealth.setValue(g.getHealth());
        progressBarHealth.setStringPainted(false);
        progressBarHealth.setPreferredSize(d3);
        progressBarHealth.setBorder(BorderFactory.createLineBorder(new Color(0x8080ff), border1));        
        cp.add(progressBarHealth, new GridBagConstraints(1, gridY, 2, 1, 0.4, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 0), 0, 0));
        
        // Age
        gridY++;
        labAge = new JLabel("Возраст: ", SwingConstants.CENTER);
        labAge.setPreferredSize(d1);
        labAge.setBorder(BorderFactory.createLineBorder(bcolor, border1));
        cp.add(labAge, new GridBagConstraints(0, gridY, 1, 1, 0.3, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 0), 0, 0));
            
        labAgeVal = new JLabel("0", SwingConstants.CENTER);
        labAgeVal.setPreferredSize(new Dimension(200, 30));
        labAgeVal.setBorder(BorderFactory.createLineBorder(bcolor, border1));
        cp.add(labAgeVal, new GridBagConstraints(1, gridY, 1, 1, 0.1, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 10), 0, 0));

        // Joy
        gridY++;
        labJoy = new JLabel("Радость: ", SwingConstants.CENTER);
        labJoy.setPreferredSize(d1);
        labJoy.setBorder(BorderFactory.createLineBorder(bcolor, border1));
        cp.add(labJoy, new GridBagConstraints(0, gridY, 1, 1, 0.3, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 0), 0, 0));
            
        labJoyVal = new JLabel("", SwingConstants.CENTER);
        labJoyVal.setPreferredSize(d2);
        labJoyVal.setBorder(BorderFactory.createLineBorder(bcolor, border1));
        cp.add(labJoyVal, new GridBagConstraints(4, gridY, 1, 1, 0.1, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 10), 0, 0));

        progressBarJoy = new JProgressBar(g.MIN_JOY, g.MAX_JOY);
        progressBarJoy.setValue(g.getJoy());
        progressBarJoy.setStringPainted(false);
        progressBarJoy.setPreferredSize(d3);
        progressBarJoy.setBorder(BorderFactory.createLineBorder(new Color(0x8080ff), border1));        
        cp.add(progressBarJoy, new GridBagConstraints(1, gridY, 2, 1, 0.4, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 0), 0, 0));     
        // fullness 
        gridY++;
        labfullness = new JLabel("Сытость: ", SwingConstants.CENTER);
        labfullness.setPreferredSize(d1);
        labfullness.setBorder(BorderFactory.createLineBorder(bcolor, border1));
        cp.add(labfullness, new GridBagConstraints(0, gridY, 1, 1, 0.3, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 0), 0, 0));
            
        labfullnessVal = new JLabel("", SwingConstants.CENTER);
        labfullnessVal.setPreferredSize(d2);
        labfullnessVal.setBorder(BorderFactory.createLineBorder(bcolor, border1));
        cp.add(labfullnessVal, new GridBagConstraints(3, gridY, 1, 1, 0.1, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 10), 0, 0));
            
        labAvailableFood = new JLabel("Еда: ", SwingConstants.CENTER);
        labAvailableFood.setPreferredSize(d2);
        labAvailableFood.setBorder(BorderFactory.createLineBorder(bcolor, border1));
        cp.add(labAvailableFood, new GridBagConstraints(4, gridY, 1, 1, 0.1, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 10), 0, 0));

        progressBarfullness = new JProgressBar(g.MIN_FULLNESS, g.MAX_FULLNESS);
        progressBarfullness.setValue(g.getfullness());
        progressBarfullness.setStringPainted(false);
        progressBarfullness.setPreferredSize(d3);
        progressBarfullness.setBorder(BorderFactory.createLineBorder(new Color(0x8080ff), border1));        
        cp.add(progressBarfullness, new GridBagConstraints(1, gridY, 2, 1, 0.4, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 0), 0, 0));        //
                
        
        cp.setBackground(new Color(235,235,230));
        setSize(800, 500);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
       
        
        gridY++;
        
        labState = new JLabel(g.getState(), SwingConstants.CENTER);
        labState.setPreferredSize(d3);
        labState.setBorder(BorderFactory.createLineBorder(new Color(0x000000), 1));
        cp.add(labState, new GridBagConstraints(3, gridY, 2, 1, 0.1, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 10), 0, 0));
        
        speedSlider = new JSlider(JSlider.HORIZONTAL, 100, 1000, 500);
        speedSlider.setPreferredSize(d3);
        cp.add(speedSlider, new GridBagConstraints(0, gridY, 2, 1, 0.1, 0.01,
            GridBagConstraints.PAGE_END, GridBagConstraints.HORIZONTAL, new Insets(10, 10, 0, 10), 0, 0));
        speedSlider.addChangeListener(new ChangeListener() {
            public void stateChanged(ChangeEvent event) {
                mTimer.setDelay(((JSlider)event.getSource()).getValue());
            }
        });
        
        gridY++;
        JButton btnStep = new JButton("Шаг");
        btnStep.addActionListener(new ActionListener(){
            public void actionPerformed(ActionEvent e) {
                step();
            }
        });
        cp.add(btnStep, new GridBagConstraints(2, gridY, 1, 1, 1, 0.99, GridBagConstraints.SOUTH,
            GridBagConstraints.HORIZONTAL, new Insets(0, 0, 0, 0), 0, 0));
            
        JButton btnFeed = new JButton("Покормить");
        btnFeed.addActionListener(new ActionListener(){
            public void actionPerformed(ActionEvent e) {
                g.food(2);
            }
        });
        cp.add(btnFeed, new GridBagConstraints(3, gridY, 1, 1, 1, 0.99, GridBagConstraints.SOUTH,
            GridBagConstraints.HORIZONTAL, new Insets(0, 0, 0, 0), 0, 0));
            
        JButton btnPlay = new JButton("Поиграть");
        btnPlay.addActionListener(new ActionListener(){
            public void actionPerformed(ActionEvent e) {
                g.play();
            }
        });
        cp.add(btnPlay, new GridBagConstraints(4, gridY, 1, 1, 1, 0.99, GridBagConstraints.SOUTH,
            GridBagConstraints.HORIZONTAL, new Insets(0, 0, 0, 0), 0, 0));       
           
        JButton btn = new JButton("Закрыть");
        btn.addActionListener(new ActionListener(){
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });
        cp.add(btn, new GridBagConstraints(0, gridY, 2, 1, 1, 0.99, GridBagConstraints.SOUTH,
            GridBagConstraints.HORIZONTAL, new Insets(0, 0, 0, 0), 0, 0));
           
        mTimer.start(); 
        
        // Status
        createStatusComps(statusPanel);
                    
    }

    public static void main(String[] args) {
        self = new tamagoMain();
        self.setVisible(true);
    }
}