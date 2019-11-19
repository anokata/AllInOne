public class Constr {
    public static void main(String[] args) {
        A a = new A();
        B b = new B();
        C c = new C();
        a = new A(1);
        D d = new D(2);
        E e = new E();
        e = new E(1, 2.0f);
        e = new E(2.0f, 4);
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

abstract class F {
    int a;
    F() {
        a = 8;
    }
}

class E extends F {
   E() {
       System.out.println("E:" + a);
       // super(); can not be not first
   } 

   E(int a, float b) {
       System.out.println("E:" + a + b);
   }
   
   E(float b, int a) {
       this(a, b); // call other constructor
   }
}
