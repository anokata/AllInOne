public class Global {
    private Global() {} // недоступный конструктор

    public static final int One = 1;


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
    }
}
