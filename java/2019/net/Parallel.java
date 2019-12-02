import java.util.*;

class Parallel {
    long millis = new Date().getTime();
    public static void main(String[] args) {
        Parallel app = new Parallel();
    }

    Parallel () {
        System.out.println("Created Parallel");
        Task job = new Task();
        Thread t = new Thread(job);
        t.start();
        while (true) {
            long newmillis = (new Date()).getTime();
            long delta = newmillis - millis;
            millis = newmillis;
            System.out.println("Main..." + (delta - 100));
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {e.printStackTrace();}
        }
    }
}


class Task implements Runnable {
    long millis = new Date().getTime();
    public void run() {
        while (true) {
            long newmillis = (new Date()).getTime();
            long delta = newmillis - millis;
            millis = newmillis;
            System.out.println("Jobing..." + (delta - 200));
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {e.printStackTrace();}
        }
    }
}

