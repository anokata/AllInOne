class Waitress {
    PancakeHouseMenu pancake;
    DinerMenu diner;

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
        Iterator pancakeIterator = pancake.createIterator();
        Iterator dinerIterator = diner.createIterator();
        System.out.println("MENU\n----\nBREAKFAST");
    }
}

