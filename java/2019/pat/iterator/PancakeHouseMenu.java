import java.util.*;

class PancakeHouseMenu {
    ArrayList<MenuItem> menuItems;

    public static void main(String[] args) {
        PancakeHouseMenu app = new PancakeHouseMenu();
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
    
    public ArrayList<MenuItem> getMenuItems() { return menuItems; }
}

