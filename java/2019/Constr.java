public class Constr {
    public static void main(String[] args) {
        A a = new A();
        B b = new B();
        C c = new C();
        a = new A(1);
        D d = new D(2);
    }
}

class A {
    A() {
        System.out.println("construct A");
    }
    A(int x) {
        System.out.println("construct A with " + x);
    }
}

class B extends A {
    B() {
    }
}

class C extends A {
    C() {
        super();
        System.out.println("construct C");
    }
}

class D {
    D(int x) {
    }
}
