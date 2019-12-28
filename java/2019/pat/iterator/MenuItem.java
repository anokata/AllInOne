class MenuItem {
    String name;
    String description;
    boolean vegetarian;
    double price;

    public static void main(String[] args) {
        MenuItem app = new MenuItem("bliny", 10.0);
    }

    MenuItem (String name,
              String description,
              boolean vegetarian,
              double price) {
        System.out.println("Created " + name + " " + price + "$");
    }

    MenuItem (String name, double price) {
        this(name, "", false, price);
    }
}

