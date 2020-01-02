import java.util.Iterator;
import java.util.*;

class CafeMenu implements Menu {
    HashMap<String, MenuItem> menuItems = new HashMap<String, MenuItem>();

    public static void main(String[] args) {
        CafeMenu app = new CafeMenu();
    }

    CafeMenu () {
        System.out.println("Created CafeMenu");
        addItem("Bugreg", "Veggie", true, 3.99);
        addItem("Soup of the day", "with salad", false, 3.69);
        addItem("Burrito", "large", true, 4.29);
    }

    public void addItem(String name, String desc, boolean v, double price) {
        MenuItem item = new MenuItem(name, desc, v, price);
        menuItems.put(item.getName(), item);
    }

    public Iterator<MenuItem> createIterator() {
        return menuItems.values().iterator();
    }
}

