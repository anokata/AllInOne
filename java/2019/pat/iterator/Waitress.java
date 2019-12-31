import java.util.Iterator;

class Waitress {
    Menu pancake;
    Menu diner;
    Menu cafe;

    public static void main(String[] args) {
        Waitress app = new Waitress();
    }

    Waitress () {
        System.out.println("Created Waitress");
        this.pancake = new PancakeHouseMenu();
        this.diner = new DinerMenu();
        cafe = new CafeMenu();
        printMenu();
    }

    public void printMenu() {
        Iterator<MenuItem> pancakeIterator = pancake.createIterator();
        Iterator<MenuItem> dinerIterator = diner.createIterator();
        Iterator<MenuItem> cafeIterator = cafe.createIterator();
        System.out.println("MENU\n----\nBREAKFAST");
        printMenu(pancakeIterator);
        System.out.println("\nLUNCH");
        printMenu(dinerIterator);
        System.out.println("\nDinner");
        printMenu(cafeIterator);
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

