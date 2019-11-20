import java.util.*;

public class Global {
    private Global() {} // недоступный конструктор

    public static final int ONE;
    public static int count = 1;

    static { // Initializator
        ONE = (int) (Math.random() * 100);
        count = ONE;
    }


    public static void print(String s) {
        System.out.println(s);
    }
    public static void print(int x) {
        System.out.println("int:" + x);
    }

    public static void main(String[] args) {
        System.out.println("Test Global:");
        Global.print("hi");
        Global.print(123);

        System.out.println(Global.count);
        Tester.test();
        System.out.println(Global.count);
        wrappers();
    }

    static void wrappers() {
        Integer i = new Integer(2);
        System.out.println(i.intValue());
        boolean b = false;
        Boolean wb = new Boolean(b);
        ArrayList<Integer> a new ArrayList<Integer>();
    }
}

class Tester {
    public static void test() {
        Global.count++;
    }
}

final class Const {
    final int x = 4*18;
    final void dosome(final int z) {
        final int y = z;
    }
}
