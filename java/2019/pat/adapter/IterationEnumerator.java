import java.util.*;

class IterationEnumerator implements Enumeration<Object> {
    public static void main(String[] args) {
        ArrayList<Object> l = new ArrayList<Object>();
        l.add(2);
        l.add(3);
        IterationEnumerator iteratorAsEnumerator = new IterationEnumerator(l.iterator());
        System.out.println(l);

        System.out.println(iteratorAsEnumerator);
        while (iteratorAsEnumerator.hasMoreElements()) {
            System.out.println("Elem: " + iteratorAsEnumerator.nextElement());
        }
    }

    private Iterator<?> iterator;

    IterationEnumerator (Iterator<Object> i) {
        System.out.println("Created IterationEnumerator");
        this.iterator = i;
    }

    public boolean hasMoreElements() {
        return iterator.hasNext();
    }

    public Object nextElement() {
        return iterator.next();
    }
}

