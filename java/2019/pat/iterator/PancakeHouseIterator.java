import java.util.*;

class PancakeHouseIterator implements Iterator {
    ArrayList<MenuItem> items;
    int position = 0;

    public static void main(String[] args) {
        // Test
        ArrayList<MenuItem> t = new ArrayList<MenuItem>();
        t.add(new MenuItem("Test", 0));
        PancakeHouseIterator i = new PancakeHouseIterator(t);
        while (i.hasNext()) {
            System.out.println(i.next());
        }
    }

    PancakeHouseIterator (ArrayList<MenuItem> lst) {
        this.items = lst;
        System.out.println("Created PancakeHouseIterator");
    }

    public Object next() {
        MenuItem item = items.get(position);
        position++;
        return item;
    }

    public boolean hasNext() {
        if (position >= items.size() || items.get(position) == null) {
            return false;
        }
        return true;
    }
}

