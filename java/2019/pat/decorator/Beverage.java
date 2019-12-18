abstract class Beverage {
    String description = "Unknow beverage";
    public String getDescription() { return description; }

    abstract public double cost();

    public static void main(String[] args) {
    }

    Beverage () {
        System.out.println("Created Beverage");
    }
}

