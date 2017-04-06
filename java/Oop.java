import java.lang.*;
import java.math.*;
import java.util.*;
import java.util.function.*;
import java.io.*;

class Animal implements Serializable {
    private final String name;

    public Animal(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Animal) {
            return Objects.equals(name, ((Animal) obj).name);
        }
        return false;
    }

    public String getName() {
        return name;
    }
}
 
public class Oop {
    public static Animal[] deserializeAnimalArray(byte[] data) { 
        try (ObjectInputStream ds = new ObjectInputStream(
                new ByteArrayInputStream(data))) {
            int n = ds.readInt();
            Animal[] animals = new Animal[n];
            for (int i = 0; i < n; i++) {
                animals[i] = (Animal) ds.readObject();
            }
            return animals;
        } catch (IOException e) {
            throw new IllegalArgumentException();
        }
        catch (ClassNotFoundException e) {
            throw new IllegalArgumentException();
        }
        catch (Exception e) {
            throw new IllegalArgumentException();
        }
    }

    public static void main(String[] args) throws IOException {
        ByteArrayOutputStream buf = new ByteArrayOutputStream();
        ObjectOutputStream bs = new ObjectOutputStream(buf);
        Animal afish = new Animal("Fish");
        Animal adog = new Animal("Dog");
        bs.writeInt(2);
        bs.writeObject(afish);
        bs.writeObject(adog);
        System.out.println("animal bytes: " + Arrays.toString(buf.toByteArray()));
        Animal[] animals = deserializeAnimalArray(buf.toByteArray());
        if (animals == null) return;
        for (Animal a : animals) {
            System.out.println("get animal: " + a.getName());
        }
        bs.close();

        System.out.println("Hi!\u03A9");
        System.out.println(integrate(x -> -x*x * Math.sin(x), 0, 10));
        AsciiCharSequence a = new AsciiCharSequence("some");
        System.out.println(a.toString() + a.charAt(0) + a.charAt(3) + a.subSequence(1,2));
        System.out.println(checkLabels(new TextAnalyzer[] {new SpamAnalyzer(new String[] {"sam"})}, "some spam text").name());
        time(new Runnable() {
            @Override
            public void run() {
                String s = "";
                for (int i = 0; i < 50000; i++) {
                    s += "a";
                }
            }
        });
        time(new Runnable() {
            @Override
            public void run() {
                StringBuffer s = new StringBuffer();
                for (int i = 0; i < 50000; i++) {
                    s.append("a");
                }
                String s1 = s.toString();
            }
        });
    }


    static public void time(Runnable func) {
        System.out.println("time: " + timeit(func));
    }

    static public long timeit(Runnable func) {
        long time = System.currentTimeMillis();
        func.run();
        return System.currentTimeMillis() - time;
    }

    static public Label checkLabels(TextAnalyzer[] analyzers, String text) {
        for (TextAnalyzer analizer : analyzers) {
            Label l = analizer.processText(text);
            if (l != Label.OK) return l;
        }
        return Label.OK;
    }

    public static double integrate(DoubleUnaryOperator f, double a, double b) {
        int n = 1;
        double eps = 0.000001;
        double result = 0;
        double old = 0;
        do {
            old = result;
            result = 0;
            double h = (b - a) / n;
            for(int i = 0; i < n; i++) {
                result += f.applyAsDouble(a + h * (i + 0.5));
            }
            n *= 2;
            //System.out.println("n " + n + " r " + result + " " + (result - old));
            result *= h;
        } while (Math.abs(result - old) > eps);
        return result;
    }

    static class AsciiCharSequence implements CharSequence {
        byte str[];

        public AsciiCharSequence(byte i[]) {
            str = i;
        }
        public AsciiCharSequence(String s) {
            str = new byte[s.length()];
            for (int i = 0; i < s.length(); i++) {
                str[i] = (byte)s.charAt(i);
            }
        }
        public char charAt(int index) {
            return (char)str[index];
        }
        public int length() {
            return str.length;
        }

        public CharSequence subSequence(int start, int end) {
            String s = "";
            for (int i = start; i < end; i++) {
                s += (this.charAt(i));
            }
            CharSequence c = new AsciiCharSequence(s);
            return c;
        }

        public String toString() {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < str.length; i++) {
                sb.append(this.charAt(i));
            }
            return sb.toString();
        }
    }
}

enum Label {
    SPAM, NEGATIVE_TEXT, TOO_LONG, OK
}

interface TextAnalyzer {
    Label processText(String text);
}

abstract class KeywordAnalyzer implements TextAnalyzer { 
    protected abstract String[] getKeywords();
    protected abstract Label getLabel();

    public Label processText(String text) {
        for (String word : getKeywords()) {
            if (text.contains(word)) {
                return getLabel();
            }
        }
        return Label.OK;
    }
}

class SpamAnalyzer extends KeywordAnalyzer {
    private String[] keywords;
    public SpamAnalyzer(String[] keywords) {
        this.keywords = keywords;
    }
    protected String[] getKeywords() {
        return this.keywords;
    }

    protected Label getLabel() {
        return Label.SPAM;
    }
}

class NegativeTextAnalyzer extends KeywordAnalyzer {
    private String[] smiles = {":(", "=(", ":|"};

    public NegativeTextAnalyzer() {
    }

    protected String[] getKeywords() {
        return this.smiles;
    }

    protected Label getLabel() {
        return Label.NEGATIVE_TEXT;
    }
}

class TooLongTextAnalyzer implements TextAnalyzer {
    private int maxLength;

    public TooLongTextAnalyzer(int max) {
        this.maxLength = max;
    }
    public Label processText(String text) {
        if (text.length() > maxLength) return Label.TOO_LONG;
        return Label.OK;
    }
}
