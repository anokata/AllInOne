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
        this.name = name;
        this.description = description;
        this.price = price;
        this.vegetarian = vegetarian;
    }

    MenuItem (String name, double price) {
        this(name, "", false, price);
    }

    public String getName() { return name; }
    public String getDescription() { return description; }
    public double getPrice() { return price; }
    public boolean isVegetarian() { return vegetarian; }

    public String toString() {
        return "MenuItem: " + name + " $" + price;
    }
}

