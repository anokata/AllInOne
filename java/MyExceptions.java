//java.lang.Throwable
import java.math.*;

class MyExceptions {
    public static void main(String[] args) {
        try {
            throw new MyException("Hi");
        } catch (MyException ex) {
            System.out.println("cathed my exception");
        }
        cast_exception(new A());
        try {
            cast_exception(new B());
        } catch (ClassCastException ex) {
            System.out.println("cast ex");
        }
        sqrt(2);
        //sqrt(-2);
        System.out.println(getCallerClassAndMethodName());
        anotherMethod();
    }

    private static void anotherMethod() {
        System.out.println(getCallerClassAndMethodName());
    }

    public static String getCallerClassAndMethodName() {
        try {
            throw new RuntimeException("");
        } catch (RuntimeException ex) {
            StackTraceElement[] st = ex.getStackTrace();
            if (st.length < 3) {
                return null;
            }
            return st[st.length-1].getClassName() + "#" + st[st.length-1].getMethodName();
        }
    }
    
    public static double sqrt(double x) {
        if (x < 0) {
            throw new IllegalArgumentException("Expected non-negative number, got " + x);
        }
        return Math.sqrt(x);
    }

    public static void cast_exception(Object b) {
        A a = (A) b;
    }
    
    static class A {
        int a;
    }

    static class B {
        double b;
    }
}

class MyException extends RuntimeException {
    public MyException(String msg) {
        super("My message is: " + msg);
    }
}
