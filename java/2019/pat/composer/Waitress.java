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

        Waitress app = new Waitress(all);
        app.printMenu();
    }

    Waitress (MenuComponent m) {
        this.menus = m;
    }
    
    public void printMenu() {
        menus.print();
    }
}

