class DarkRoast extends Beverage {
    public String getDescription() {
        return "DarkRoast";
    }

    public double cost() {
        return 0.99;
    }

    public static void main(String[] args) {
        DarkRoast app = new DarkRoast();
    }

    DarkRoast () {
        System.out.println("Created DarkRoast");
    }
}

