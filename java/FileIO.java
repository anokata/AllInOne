import java.io.File;
import java.io.IOException;
import java.util.logging.*;
import java.nio.file.*;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.*;
import java.io.ByteArrayOutputStream;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.util.Arrays;
import java.io.Reader;
import java.io.InputStreamReader;
import java.util.Scanner;
import java.nio.charset.StandardCharsets;
import java.nio.charset.Charset;

/**
 *
 * */
class Main {
    static public void main(String[] args) throws IOException {
        //crlftolf(System.in, System.out);
        //System.out.flush()
        byte[] b = {13,1,13,2,10,1,10,2,10,13,4,13,10,65, 13, 10, 10, 13, 64, 62, 10, 13, 2};
        byte[] o; 
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        crlftolf(new ByteArrayInputStream(b), out);
        System.out.println(Arrays.toString(out.toByteArray()));
        System.out.println("end");
        test_reader();
        test_scanner();
        byte[] testb = {48, 49, 50, 51, 10, 49, 49};
        System.out.println(readAsString(new ByteArrayInputStream(testb), StandardCharsets.US_ASCII));

        inDoubleSum(new StringBufferInputStream("123.12\n8.08\na2\n1\n2asf 100"));
    }

    static public void test_scanner() throws IOException, FileNotFoundException {
        Reader reader = new StringReader("123,231,some");
        Scanner scanner = new Scanner(reader)
            .useDelimiter(",");
        int i = scanner.nextInt();
        System.out.println(i);
        i = scanner.nextInt();
        System.out.println(i);
        String s = scanner.next();
        System.out.println(s);

        InputStream in = new FileInputStream("input");
        i = in.read();
        System.out.println(i);
        i = in.read();
        System.out.println(i);
        i = in.read();
        System.out.println(i);
        in.close();

        Writer writer = new OutputStreamWriter(System.out, StandardCharsets.US_ASCII);
        writer.write("ЯЧС");
        writer.write("123");
        writer.flush();
    }

    public static void sumDouble() {
        inDoubleSum(System.in);
    }

    public static void inDoubleSum(InputStream in) {
        double sum = 0;
        try (Scanner scan = new Scanner(new InputStreamReader(in))) {
            while (scan.hasNext()) {
                String s = scan.next();
                try {
                    sum += Double.parseDouble(s);
                } catch (NumberFormatException e) {}
            }
        } 
        System.out.printf("%.6f", sum);
    }

    public static String readAsString(InputStream inputStream, Charset charset) throws IOException {
        String out = "";
        try (BufferedReader in = new BufferedReader(new InputStreamReader(inputStream, charset))) {
            char c;
            int i;
            do {
                i = in.read();
                c = (char)i;
                if (i > 0)
                    out += c;
            }
            while (i > 0);
        }
        return out;
    }

    static public void test_reader() throws IOException, FileNotFoundException, UnsupportedEncodingException {
        System.out.println("* Test Reader");
        InputStream in = new FileInputStream("FileIO.java");
        Reader r = new InputStreamReader(in, "UTF-8");
        char[] buf = new char[100];
        r.read(buf);
        System.out.println(new String(buf));
        r.close();

        try (BufferedReader reader = Files.newBufferedReader(Paths.get("Oop.java"))) {
            String line = "";
            int i = 3;
            while (i-- > 0 && line != null) {
                System.out.println(i + ") " + line);
                line = reader.readLine();
            }
        }
        System.out.println("+ Test Reader");

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
