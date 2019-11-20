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
        ArrayList<Integer> a = new ArrayList<Integer>();
        Integer x = unboxi() * new Integer(123);
        x++;
        float f = x^2;
        Float ff = f;
        Double d = (double) ff;
        System.out.println(d);

        int j;
        Integer ii = new Integer(0);
        j = ii;
        System.out.println(j);
        System.out.println(ii);
        Double dd = new Double("0.0");
        Integer ing = new Integer("111");
 
        System.out.println((new Boolean("true")).toString());
        //printf
        System.out.println(String.format("%,d %d hi", Math.round(Math.pow(2,30)), 10));
    }

    static Integer unboxi() {
        return 1;
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
