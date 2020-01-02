import java.util.Iterator;
import java.util.*;

class DinerMenuIterator implements Iterator {
    MenuItem[] items;
    int position = 0;

    public static void main(String[] args) {
        // Test
        MenuItem[] t = {new MenuItem("Test", 0)};
        DinerMenuIterator i = new DinerMenuIterator(t);
        while (i.hasNext()) {
            System.out.println(i.next());
        }
    }

    DinerMenuIterator (MenuItem[] menu) {
        System.out.println("Created DinerMenuIterator");
        this.items = menu;
    }

    public MenuItem next() {
        MenuItem item = items[position];
        position++;
        return item;
    }

    public boolean hasNext() {
        if (position < items.length && items[position] != null) {
            return true;
        } else {
            return false;
        }
    }

    public void remove() {
        throw new IllegalStateException();
    }
}

