import java.io.*;

class CL {
    public static void main(String[] args) {
        System.out.println(CL.class.getClassLoader());
        System.out.println(Sub.class.getClassLoader());
        MyLoader m = new MyLoader();
        Class <?> h;
        try {
            h = m.findClass("Hello");
        } catch (ClassNotFoundException ex) {
            return;
        }
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
