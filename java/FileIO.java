import java.io.File;
import java.io.IOException;
import java.util.logging.*;
import java.nio.file.*;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.util.Arrays;

class Main {
    static public void main(String[] args) {
        //crlftolf(System.in, System.out);
        //System.out.flush()
        byte[] b = {13,1,13,2,10,1,10,2,10,13,4,13,10,65, 13, 10, 10, 13, 64, 62, 10, 13, 2};
        byte[] o; 
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        crlftolf(new ByteArrayInputStream(b), out);
        System.out.println(Arrays.toString(out.toByteArray()));
        System.out.println("end");
    }

    static public void crlftolf(InputStream in, OutputStream out) {
        int b;
        try {
            while ((b = in.read()) > 0) {
                if (b == 13) {
                    b = in.read();
                    if (b != 10) {
                        out.write(13);
                    } 
                    out.write(b);
                } else {
                    out.write(b);
                }
            }
        } catch (IOException e) {}
    }
}

public class FileIO {
    static public final Logger LOG =
        Logger.getLogger(FileIO.class.getName());

    public static void iofile() {
        File cur = new File("FileIO.java");
        File c = new File(".");
        LOG.log(Level.INFO, "path: {0}", cur.getAbsolutePath());
        LOG.log(Level.INFO, "path: {0}", cur.getName());
        try {
            LOG.log(Level.INFO, "path: {0}", c.getCanonicalPath());
        } catch (IOException e) {
            LOG.log(Level.WARNING, "path canonical error ");
        }
        System.out.println("exists: " + c.exists());
        System.out.println("isfile: " + c.isFile());
        System.out.println("isdir: " + c.isDirectory());
        System.out.println("len: " + c.length());
        System.out.println("date mod: " + c.lastModified());
        int i = 4;
        for (String str : c.list((d, f) -> f.endsWith(".java"))) {
            System.out.println("contain: " + str);
            if (i-- == 0) break;
        }
    }

    public static void niofile() throws IOException {
        Path p = Paths.get(".");
        LOG.log(Level.INFO, "path: {0}", p.toFile().getAbsolutePath());
        LOG.log(Level.INFO, "path: {0}", Files.size(p));
    }

    public static void arrayRef(int[] b) {
        b[0]++;
    }

    public static void main(String[] args) throws IOException {
        iofile();
        niofile();
        int[] y = {1,2,3};
        int[] x = new int[3];
        arrayRef(x);
        System.out.println(Arrays.toString(x));
        arrayRef(y);
        System.out.println(Arrays.toString(y));
        //InputStream in = new FileInputStream(new File("FileIO.java"));
        String s = ">";
        try (InputStream newin = Files.newInputStream(Paths.get("FileIO.java"))) {
            int b = newin.read();
            System.out.printf("%02x", b);
            byte[] bts = new byte[20];
            newin.read(bts);
            System.out.println(new String(bts));
        }
        try (DataInputStream din = new DataInputStream(Files.newInputStream(Paths.get("FileIO.java")))) {
            s = din.readUTF();
            System.out.println(s);
        } catch (Exception e) {
            System.out.println(s);
        }
        try (InputStream in = Files.newInputStream(Paths.get("Hello.java"))) {
            System.out.println(checkSumOfStream(in));
        }
        Main.main(null);
    }

    public static int checkSumOfStream(InputStream inputStream) throws IOException {
        int sum = 0;
        int b;
        while ((b = inputStream.read()) > 0) {
            sum = Integer.rotateLeft(sum, 1) ^ b;
        }
        return sum;
    }
}
