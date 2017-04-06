import java.lang.*;
import java.math.*;
import java.util.*;
import java.util.function.*;
import java.io.*;
import java.util.logging.*;

interface Sendable {
    String getFrom();
    String getTo();
}

abstract class AbstractSendable implements Sendable {

    protected final String from;
    protected final String to;

    public AbstractSendable(String from, String to) {
        this.from = from;
        this.to = to;
    }

    @Override
    public String getFrom() {
        return from;
    }

    @Override
    public String getTo() {
        return to;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AbstractSendable that = (AbstractSendable) o;
        if (!from.equals(that.from)) return false;
        if (!to.equals(that.to)) return false;
        return true;
    }
}

class MailMessage extends AbstractSendable {

    private final String message;

    public MailMessage(String from, String to, String message) {
        super(from, to);
        this.message = message;
    }

    public String getMessage() {
        return message;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;

        MailMessage that = (MailMessage) o;

        if (message != null ? !message.equals(that.message) : that.message != null) return false;

        return true;
    }
}

class MailPackage extends AbstractSendable {
    private final Package content;

    public MailPackage(String from, String to, Package content) {
        super(from, to);
        this.content = content;
    }

    public Package getContent() {
        return content;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;

        MailPackage that = (MailPackage) o;

        if (!content.equals(that.content)) return false;

        return true;
    }
}

class Package {
    private final String content;
    private final int price;

    public Package(String content, int price) {
        this.content = content;
        this.price = price;
    }

    public String getContent() {
        return content;
    }

    public int getPrice() {
        return price;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Package aPackage = (Package) o;

        if (price != aPackage.price) return false;
        if (!content.equals(aPackage.content)) return false;

        return true;
    }
}

interface MailService {
    Sendable processMail(Sendable mail);
}

class RealMailService implements MailService {

    public static final Logger LOGGER = 
        Logger.getLogger("mail");

    @Override
    public Sendable processMail(Sendable mail) {
        if (mail instanceof MailPackage) {
            MailPackage pkg = (MailPackage) mail;
            LOGGER.info("real PACKAGE " + pkg.getContent().getContent() + " prc " + 
                    pkg.getContent().getPrice());
        }
        LOGGER.info("real proc " + mail.getFrom());
        return mail;
    }
}

class UntrustworthyMailWorker implements MailService {

    private MailService realService;
    private MailService[] chain;

    public MailService getRealMailService() {
        return realService;
    }

    public UntrustworthyMailWorker(MailService[] chain) {
        this.chain = chain;
        this.realService = new RealMailService();
    }
    
    @Override
    public Sendable processMail(Sendable mail) {
        for (MailService ms : chain) {
            mail = ms.processMail(mail);
        }
        return realService.processMail(mail);
    }
}

class Spy implements MailService {

    public static final String AUSTIN_POWERS = "Austin Powers";

    private Logger logger;

    public Spy(Logger log) {
        this.logger = log;
    }

    @Override
    public Sendable processMail(Sendable mail) {
        if (mail instanceof MailMessage) {
            MailMessage msg = (MailMessage) mail;
            if (mail.getFrom().equals(AUSTIN_POWERS) || mail.getTo().equals(AUSTIN_POWERS)) {
                logger.log(Level.WARNING, 
                        "Detected target mail correspondence: from " +
                        mail.getFrom() + " to " + mail.getTo() + " \"" + msg.getMessage() + "\"");
            } else {
                logger.log(Level.INFO, 
                        "Usual correspondence: from {0} to {1}", new Object[] {mail.getFrom(), mail.getTo()});
            }
        }
        return mail;
    }
}

class Thief implements MailService {
    int min_price;
    int sum;

    public Thief(int min) {
        min_price = min;
        sum = 0;
    }

    public int getStolenValue() {
        return sum;
    }
    
    @Override
    public Sendable processMail(Sendable mail) {
        if (mail instanceof MailPackage) {
            MailPackage pkg = (MailPackage) mail;
            if (pkg.getContent().getPrice() < min_price) return mail;

            MailPackage change = new MailPackage(pkg.getFrom(), pkg.getTo(), 
                    new Package("stones instead of " + pkg.getContent().getContent(), 0));
            sum += pkg.getContent().getPrice();
            return change;
        }
        return mail;
    }
}

class IllegalPackageException extends RuntimeException { }
class StolenPackageException extends RuntimeException { }

class Inspector implements MailService {

    public static final String WEAPONS = "weapons";
    public static final String BANNED_SUBSTANCE = "banned substance";

    @Override
    public Sendable processMail(Sendable mail) {
        if (mail instanceof MailPackage) {
            MailPackage pkg = (MailPackage) mail;
            String content = pkg.getContent().getContent();
            if (content.contains(WEAPONS) || 
                    content.contains(BANNED_SUBSTANCE)) {
                throw new IllegalPackageException();
            }
            if (content.contains("stones")) {
                throw new StolenPackageException();
            }
        }
        return mail;
    }
}

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
    public static final Logger LOGGER = 
        Logger.getLogger("mail");

    public static void test_mail() {
        RealMailService r = new RealMailService();
        Spy s = new Spy(LOGGER);
        Thief t = new Thief(10);
        Inspector i = new Inspector();
        UntrustworthyMailWorker u = new UntrustworthyMailWorker(
                new MailService[] {r, s, i, t, r});
        MailMessage msg = new MailMessage("John", "Mary", "Hi M.");
        MailMessage msg2 = new MailMessage("Austin Powers", "Mary", "Hi M.");
        MailPackage p1 = new MailPackage("weapons", "b", new Package("neapons", 3));
        MailPackage p2 = new MailPackage("a", "b", new Package("coin", 40));
        u.processMail(msg);
        u.processMail(msg2);
        u.processMail(p1);
        u.processMail(p2);
        LOGGER.warning("package: " + p1.getContent().getContent());
        LOGGER.warning("package: " + p2.getContent().getContent());
        LOGGER.warning("thief: " + t.sum);
    }

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
        test_mail();
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
