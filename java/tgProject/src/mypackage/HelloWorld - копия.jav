package mypackage;
 import javax.swing.JFrame;
 import javax.swing.JLabel;
 import javax.swing.SwingUtilities; 
 
 public final class HelloWorld implements Runnable {
 
     public static void main(String[] args) {
         SwingUtilities.invokeLater (new HelloWorld());
     } 
 
     public void run() { 
         JFrame f = new JFrame ("Hello, World!");
         f.setDefaultCloseOperation (JFrame.DISPOSE_ON_CLOSE);
         // f.setDefaultCloseOperation (JFrame.EXIT_ON_CLOSE);
         f.add(new JLabel("Hello World"));
         f.pack();
         f.setVisible(true);
     }
 }