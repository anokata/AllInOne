import java.util.*;
import java.io.*;

class LowerCaseInputstream extends FilterInputStream {
    public static void main(String[] args) {
        int c;
        try {
            InputStream in = new LowerCaseInputstream(
                    new BufferedInputStream(
                        new FileInputStream("LowerCaseInputstream.java")));
            while((c = in.read()) >=0) {
                System.out.print((char)c);
            }
        } catch (IOException ex) { ex.printStackTrace(); }
    }

    public LowerCaseInputstream (InputStream in) {
        super(in);
        System.out.println("Created LowerCaseInputstream");
    }

    public int read() throws IOException {
        int c = in.read();
        return (c == -1 ? c : Character.toLowerCase((char)c));
    }

    public int read(byte[] b, int offset, int len) throws IOException {
        int result = in.read(b, offset, len);
        for (int i = offset; i < offset+result; i++) {
            b[i] = (byte) Character.toLowerCase((char)b[i]);
        }
        return result;
    }
}

