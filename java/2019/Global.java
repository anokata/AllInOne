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
    }
}

class Tester {
    public static void test() {
        Global.count++;
    }
}
