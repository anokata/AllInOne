import java.io.*;
import java.net.*;

class Server1 {
    public static void main(String[] args) {
        System.out.println("Server1");
        String[] advices = {"feed cat", "sleep", "work"};
        try {
            ServerSocket serverSock = new ServerSocket(5000);
            while (true) {
                Socket sock = serverSock.accept();
                System.out.println("Connected" + sock.getLocalAddress());
                PrintWriter writer = new PrintWriter(sock.getOutputStream());
                String a = advices[(int) (Math.random() * advices.length)];
                writer.println(a);
                writer.close();
                System.out.println("I say:" + a);
            }
        } catch (IOException e) {e.printStackTrace();}
    }
}

