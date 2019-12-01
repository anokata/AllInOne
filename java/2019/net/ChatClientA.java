import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.net.*;

class ChatClientA {
    public static void main(String[] args) {
        ChatClientA app = new ChatClientA();
    }

    JTextField outgoing;
    JFrame frame;
    PrintWriter writer;
    Socket sock;
    final String serverName = "127.0.0.1";
    final int serverPort = 5000;

    ChatClientA() {
        System.out.println("ChatClientA");
        setUpGui();
    }

    private void setUpNet() {
        try {
            sock = new Socket(serverName, serverPort);
            writer = new PrintWriter(sock.getOutputStream());
            System.out.println("Connected");
        } catch (Exception ex) {ex.printStackTrace();}
    }

    private void setUpGui() {
        frame = new JFrame("Chat");
        JPanel mainPanel = new JPanel();
        outgoing = new JTextField(20);
        JButton sendButton = new JButton("Send");
        mainPanel.add(outgoing);
        mainPanel.add(sendButton);
        sendButton.addActionListener(new SendButtonListener());
        setUpNet();
        frame.setSize(300,300);
        frame.getContentPane().add(mainPanel);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
    }

    public class SendButtonListener implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            try {
                writer.println(outgoing.getText());
                writer.flush();
            } catch (Exception ex) {ex.printStackTrace();}
            outgoing.setText("");
            outgoing.requestFocus();
        }
    }
}

