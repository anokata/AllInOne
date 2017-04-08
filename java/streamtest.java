import java.util.stream.*;
import java.util.*;

class streamtest {

    public static void test_streams() {
        ArrayList a = new ArrayList();
        a.add("a");
        a.add("b");
        a.add("cde");
        a.add("edc");
        a.add("CDe");
        a.add("cDe");
        a.add("edC");
        a.add("A");
        a.add("b");
        a.add("B");
        Stream<String> s = a.stream()
            .map(x -> x.toString().toLowerCase())
            .sorted();
        s.forEach(System.out::println);
    }

    public static void main(String[] args) {
        test_streams();
    }
}
