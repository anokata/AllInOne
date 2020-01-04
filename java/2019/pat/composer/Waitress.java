import java.util.Iterator;
import java.util.*;

class Waitress {
    MenuComponent menus;

    public static void main(String[] args) {
        MenuComponent diner = new Menu("Dinner", "");
        MenuComponent pancake = new Menu("Pancake", "");
        MenuComponent cafe = new Menu("Cafe", "");
        MenuComponent dessert = new Menu("Dessert", "");
        MenuComponent all = new Menu("All", "");
        
        all.add(diner);
        all.add(cafe);
        all.add(pancake);
        
        diner.add(new MenuItem("Pasta", 3.89));
        diner.add(dessert);
        dessert.add(new MenuItem("Pie", 1.59));
        dessert.add(new MenuItem("VPie", "", true, 1.59));

        Waitress app = new Waitress(all);
        app.printMenu();

        app.printVeg();
    }

    Waitress (MenuComponent m) {
        this.menus = m;
    }
    
    public void printMenu() {
        menus.print();
    }

    public void printVeg() {
        Iterator<MenuComponent> iterator = menus.createIterator();
        System.out.println("Veg menu:");
        while (iterator.hasNext()) {
            MenuComponent item = iterator.next();
            try {
                if (item.isVegetarian()) {
                    item.print();
                }
            } catch (UnsupportedOperationException ex) {}
        }
    }
}

