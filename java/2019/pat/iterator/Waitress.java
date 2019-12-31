import java.util.Iterator;

class Waitress {
    Menu pancake;
    Menu diner;

    public static void main(String[] args) {
        Waitress app = new Waitress();
    }

    Waitress () {
        System.out.println("Created Waitress");
        this.pancake = new PancakeHouseMenu();
        this.diner = new DinerMenu();
        printMenu();
    }

    public void printMenu() {
        Iterator<MenuItem> pancakeIterator = pancake.createIterator();
        Iterator<MenuItem> dinerIterator = diner.createIterator();
        System.out.println("MENU\n----\nBREAKFAST");
        printMenu(pancakeIterator);
        System.out.println("\nLUNCH");
        printMenu(dinerIterator);
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
