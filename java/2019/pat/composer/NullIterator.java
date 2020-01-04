import java.util.Iterator;

class NullIterator implements Iterator {
    public static void main(String[] args) {
        NullIterator app = new NullIterator();
    }

    NullIterator () {
        System.out.println("Created NullIterator");
    }

    public Object next() {
        return null;
    }

    public boolean hasNext() {
        return false;
    }
}

