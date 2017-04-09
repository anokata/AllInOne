import java.io.*;

class InitTest {
    static int a = init("a");
    static int b;
    static {
        b = init("b");
        c = init("c in static block");
    }
    static int c = init("c after static block");
    int d = init("field d init");
    {
        d = init("field d init in block");
        e = init("field e init in block");
    }
    int e = init("field e init");

    static int init(String msg) {
        System.out.println(msg);
        return 1;
    }

    public InitTest() {
        init("construct");
    }
}

class CL {
    public static void main(String[] args) 
        throws ClassNotFoundException, InstantiationException, IllegalAccessException {
        Class.forName(InitTest.class.getName()).newInstance();
        System.out.println(CL.class.getClassLoader());
        System.out.println(Sub.class.getClassLoader());
        System.out.println(String.class.getClassLoader() == null ? "bootstrap" : "_");
        MyLoader m = new MyLoader();
        Class <?> h;
        try {
            h = m.findClass("Hello");
        } catch (ClassNotFoundException ex) {
            return;
        }
        /*
        URL  jarFileURL = new URL("file://some.jar");
        ClassLoader  classLoader = new  URLClassLoader(
        new URL[] {jarFileURL });
        Class c4 = classLoader.loadClass("SomeClass");
        */
    }

    class Sub {

    }
}
class MyLoader extends ClassLoader {

    @Override
    public Class<?> findClass(String className) throws ClassNotFoundException {
        byte b[];
        try {
            b = fetchClassFromFS(className + ".class");
        } catch (FileNotFoundException ex) {
            return null;
        } catch (IOException ex) {
            return null;
        }
        return defineClass(className, b, 0, b.length);
    }

    private byte[] fetchClassFromFS(String path) throws FileNotFoundException, IOException {
        InputStream is = new FileInputStream(new File(path));
        long length = new File(path).length();
        byte[] bytes = new byte[(int)length];
        int offset = 0;
        int numRead = 0;
        while (offset < bytes.length
            && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
          offset += numRead;
        }
        is.close();
        return bytes;
    }
}
