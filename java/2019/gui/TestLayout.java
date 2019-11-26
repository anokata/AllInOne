import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

class TestLayout {
    JTextField field1;
    
    public static void main(String[] args) {
        (new TestLayout()).makeGui();
    }

    public void makeGui() {
        JFrame frame = new JFrame();
        JPanel panel = new JPanel();
        JPanel enterPanel = new JPanel();
        JButton button = new JButton("show me");
        JButton button2 = new JButton("secondary");
        JButton button3 = new JButton("click me");
        JCheckBox check = new JCheckBox("Sure?");
        field1 = new JTextField(20);
        JLabel label1 = new JLabel("Enter:");
        
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        panel.setBackground(Color.darkGray);
        enterPanel.setBackground(Color.gray);
        check.setBackground(Color.gray);

        panel.add(button);
        panel.add(enterPanel);
        enterPanel.add(label1);
        enterPanel.add(field1);
        panel.add(button2);
        enterPanel.add(button3);
        enterPanel.add(check);

        frame.getContentPane().add(BorderLayout.CENTER, panel);
        frame.setSize(300,300);
        frame.setVisible(true);

        button3.addActionListener(new ButtonEnterClicker());
        field1.addActionListener(new FieldEnter());
    }

    class ButtonEnterClicker implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            System.out.println(field1.getText());
        }
    }

    class FieldEnter implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            JTextField f = (JTextField) e.getSource();
            System.out.println(f.getText());
            f.setText("");
        }
    }
}
