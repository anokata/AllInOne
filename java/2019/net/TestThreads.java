import java.util.*;
import java.io.*;

class TestThreads {
    public static void main(String[] args) {
        TestThreads app = new TestThreads();

        ThreadOne t1 = new ThreadOne();
        ThreadTwo t2 = new ThreadTwo();
        Thread one = new Thread(t1);
        Thread two = new Thread(t2);
        one.start();
        two.start();
    }

}

class Accum {
    private Accum() {}
    private int counter = 0;
    private static Accum a = new Accum();

    public static Accum getAccum() {
        return a;
    }

    public int getCount() {
        return counter;
    }

    public void updateCounter(int add) {
        counter += add;
    }
}

class ThreadOne implements Runnable {
    public void run() {
        Accum a = Accum.getAccum();
        for (int x = 0; x<98; x++) {
            a.updateCounter(1000);
        }
        System.out.println("one " + a.getCount());
    }
}

class ThreadTwo implements Runnable {
    public void run() {
        Accum a = Accum.getAccum();
        for (int x = 0; x<98; x++) {
            a.updateCounter(1);
        }
        try {
            Thread.sleep(50);
        } catch (Exception ex) { ex.printStackTrace(); }
        a.updateCounter(1);
        System.out.println("two " + a.getCount());
    }
}
