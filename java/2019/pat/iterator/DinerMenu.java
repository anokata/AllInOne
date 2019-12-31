import java.util.Iterator;

class DinerMenu implements Menu {
    static final int MAX_ITEMS = 6;
    int numberOfItems = 0;
    MenuItem[] menuItems;

    public static void main(String[] args) {
        DinerMenu m = new DinerMenu();
        Iterator i = m.createIterator();
        while(i.hasNext()) {
            MenuItem t = (MenuItem) i.next();
            System.out.println(t);
        }
    }

    DinerMenu () {
        menuItems = new MenuItem[MAX_ITEMS];

        addItem("Veg BLT", "", true, 2.99);
        addItem("BLT", "Bacon with lettuce on wheat", false, 2.99);
        addItem("Soup of the day", "", false, 3.29);
        addItem("Hotdog", "", false, 3.05);

        System.out.println("Created DinerMenu");
    }

    public void addItem(String n, String d, boolean v, double p) {
        if (numberOfItems >= MAX_ITEMS) {
            System.out.println("Menu if Full!!! Can't add.");
            return;
        }
        MenuItem item = new MenuItem(n, d, v, p);
        menuItems[numberOfItems] = item;
        numberOfItems++;
    }

    // public MenuItem[] getMenuItems() { return menuItems; }
    public Iterator<MenuItem> createIterator() {
        return new DinerMenuIterator(this.menuItems);
    }
}

