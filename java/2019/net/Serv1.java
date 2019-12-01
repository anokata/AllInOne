import java.net.*;
import java.io.*;

class Serv1 {
    public static void main(String[] args) {
        System.out.println("Serv1");
        Serv1 app = new Serv1();
    }

    Serv1() {
        try {
            Socket s = new Socket("127.0.0.1", 5000);
            InputStreamReader i = new InputStreamReader(s.getInputStream());
            BufferedReader b = new BufferedReader(i);
            PrintWriter p = new PrintWriter(s.getOutputStream());
            p.println("Hi from Java!");
            //Thread.sleep(10000);
            System.out.println(b.readLine());
            p.close();
            b.close();
        } catch (Exception e) {e.printStackTrace();}
    }
}

