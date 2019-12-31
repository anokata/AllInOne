import java.util.*;
import java.util.Iterator;

class PancakeHouseMenu implements Menu {
    ArrayList<MenuItem> menuItems;

    public static void main(String[] args) {
        PancakeHouseMenu m = new PancakeHouseMenu();
        Iterator i = m.createIterator();
        while(i.hasNext()) {
            MenuItem t = (MenuItem) i.next();
            System.out.println(t);
        }
    }

    PancakeHouseMenu () {
        menuItems = new ArrayList<MenuItem>();

        addItem("K&B's Pancake Breakfast", "", true, 2.99);
        addItem("Regular Pancake", "", false, 2.99);
        addItem("Blueberry Pancakes", "", true, 3.49);
        addItem("Waffles", "", true, 3.59);

        System.out.println("Created PancakeHouseMenu");
    }

    public void addItem(String name, String description,
                        boolean vegetarian, double price) {
        MenuItem item = new MenuItem(name, description, vegetarian, price);
        menuItems.add(item);
    }
    
    // public ArrayList<MenuItem> getMenuItems() { return menuItems; }
    public Iterator<MenuItem> createIterator() {
        //return new PancakeHouseIterator(this.menuItems);
        return this.menuItems.iterator();
    }
}

