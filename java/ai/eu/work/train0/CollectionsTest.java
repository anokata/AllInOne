import java.util.*;

public class CollectionsTest {
    public static void main(String[] args) {
        Collection<?> c = new LinkedList<Object>();
        Object o = new Object();
        Iterator i = c.iterator();
        c.clear();
        c.size();
        c.remove(o);
        c.contains(o);
        c.toArray();
        //c.add(o);
        //c.addAll(Arrays.asList(o));
    }
}
