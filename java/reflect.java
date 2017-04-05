import java.lang.Class;
import java.lang.reflect.Modifier;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Member;

enum En {Ae, Bu, Co}

class reflect {
    public static void main(String[] args) {
        System.out.println("Reflect.");
        Test t1 = new Test();
        Class class1 = t1.getClass();
        Class[] classes = new Class[20];
        classes[1] = "x".getClass();
        classes[2] = System.console().getClass();
        //Class class4 = Ae.getClass();
        classes[3] = En.class;
        classes[4] = double.class;
        classes[5] = long[].class;
        System.out.println(class1.getName());
        for (Class c : classes) {
            if (c != null)
                System.out.println(c.getName());
        }
        for (Class c : class1.getClasses()) {
            System.out.println(c.getName());
        }
        for (Class c : class1.getDeclaredClasses()) {
            System.out.println(c.getName() + " " + c.getCanonicalName());
        }
        System.out.println(Modifier.toString(class1.getModifiers()));
        System.out.println(Modifier.toString(classes[1].getModifiers()));
        System.out.println(classes[1].getPackage().getName());
        for (Field f : class1.getFields()) {
            System.out.println(f.toGenericString());
        }
        for (Field f : class1.getDeclaredFields()) {
            System.out.println(f.toGenericString());
        }
        for (Method f : class1.getMethods()) {
            System.out.println(f.toGenericString());
        }

        final Package[] packages = Package.getPackages();
        java.util.Arrays.sort(packages, (x, y) -> x.getName().compareTo(y.getName()));
        for (Package pkg : packages) {
            String name = pkg.getName();
            System.out.println(name);
        }

        try {
            Thread.currentThread().getContextClassLoader().loadClass("java.util.ArrayList");
            Class c = Class.forName("java.lang.Thread");
            for (Method f : c.getMethods()) {
                System.out.println(f.toGenericString());
            }
        } catch (ClassNotFoundException e) {}
}
}

class Test {
    private int f;
    public String s;
    class SubTest {
    }
}

class HerTest extends Test {
}


