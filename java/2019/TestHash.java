import java.util.*;

class TestHash {
    public static void main(String[] args) {
        TestHash app = new TestHash();
    }

    TestHash () {
        System.out.println("Created TestHash");
        HashSet<M> h = new HashSet<M>();
        h.add(new M("a"));
        h.add(new M("b"));

        M m = null;
        Iterator<M> i = h.iterator(); 
        while (i.hasNext()) {
            m = i.next();
            System.out.println(m);
        }
        System.out.println(h.contains(new M("x")));
    }
}

class M {
    String name;
    M(String n) { name = n; }

    public int hashCode() {
        return 1;
    }

    public String toString() { return name;}

    public boolean equals(Object o) {
        return true;
    }
}

