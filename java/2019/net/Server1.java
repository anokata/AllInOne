import java.io.*;
import java.net.*;

class Server1 {
    public static void main(String[] args) {
        System.out.println("Server1");
        try {
            ServerSocket serverSock = new ServerSocket(5000);
            Socket sock = serverSock.accept();
            System.out.println(sock.getLocalAddress());
        } catch (IOException e) {e.printStackTrace();}
    }
}

