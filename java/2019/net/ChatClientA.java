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
    JTextArea incoming;
    JFrame frame;
    PrintWriter writer;
    BufferedReader reader;
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
            InputStreamReader streamReader = new InputStreamReader(sock.getInputStream());
            reader = new BufferedReader(streamReader);
            System.out.println("Connected");
        } catch (Exception ex) {ex.printStackTrace();}
    }

    private void setUpGui() {
        frame = new JFrame("Chat");
        JPanel mainPanel = new JPanel();
        outgoing = new JTextField(20);
        JButton sendButton = new JButton("Send");
        sendButton.addActionListener(new SendButtonListener());
        setUpNet();

        incoming = new JTextArea(15,50);
        incoming.setLineWrap(true);
        incoming.setWrapStyleWord(true);
        incoming.setEditable(false);
        JScrollPane qScroller = new JScrollPane(incoming);
        qScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
        qScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

        Thread readerThread = new Thread(new IncomingReader());
        readerThread.start();

        mainPanel.add(qScroller);
        mainPanel.add(outgoing);
        mainPanel.add(sendButton);
        
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

    public class IncomingReader implements Runnable {
        public void run() {
            String message;
            try {
                while ((message = reader.readLine()) != null) {
                    System.out.println("read " + message);
                    incoming.append(message + "\n");
                }
            } catch (Exception ex) {ex.printStackTrace();}
        }
    }
}

