import java.util.*;

class Parallel {
    long millis = new Date().getTime();
    public static void main(String[] args) {
        Parallel app = new Parallel();
    }

    void test1() {
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

    void testSimultaniously() {
        Job2 job = new Job2();
        Thread t1 = new Thread(job);
        Thread t2 = new Thread(job);
        t1.start();
        t2.start();
    }

    Parallel () {
        //test1();
        testSimultaniously();
    }

    class Account {
        private int acc = 100;
        public int get() { return acc;}
        //public synchronized int take() { 
        public int take() { 
            synchronized(this) {
                if (a.get() > 0) {
                    acc -= 10; 
                }
            }
            return acc; 
        }
        public synchronized void eternity() {
            while (true) {
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {e.printStackTrace();}
                System.out.println(Thread.currentThread().getName() + " sleep...");
            }
        }
    }

    Account a = new Account();

    class Job2 implements Runnable {
        public void run() {
            //a.eternity();
            while (true) {
                    a.take();
                    try {
                        Thread.sleep(100);
                    } catch (InterruptedException e) {e.printStackTrace();}
                    System.out.println(Thread.currentThread().getName() + " " + a.get());
                }
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
            System.out.println("Jobing..." + (delta - 200) + "  " + Thread.currentThread().getName());
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {e.printStackTrace();}
        }
    }
}

