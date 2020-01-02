import java.util.Iterator;
import java.util.*;

class Waitress {
    ArrayList<Menu> menus;

    public static void main(String[] args) {
        ArrayList<Menu> menus = new ArrayList<Menu>();
        menus.add(new PancakeHouseMenu());
        menus.add(new DinerMenu());
        menus.add(new CafeMenu());
        Waitress app = new Waitress(menus);
    }

    Waitress (ArrayList<Menu> menus) {
        this.menus = menus;
        printMenu();
    }

    public void printMenu() {
        Iterator<Menu> i = menus.iterator();
        while (i.hasNext()) {
            Menu menu = i.next();
            printMenu(menu.createIterator());
        }
    }

    public void printMenu(Iterator i) {
        while (i.hasNext()) {
            MenuItem menuItem = (MenuItem) i.next();
            System.out.print(menuItem.getName() + ": ");
            System.out.print(menuItem.getPrice() + " -- ");
            System.out.println(menuItem.getDescription());
        }
    }
}

