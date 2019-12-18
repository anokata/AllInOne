class DarkRoast extends Beverage {
    public int cost() {
        return 12;
    }

    public static void main(String[] args) {
        DarkRoast app = new DarkRoast();
    }

    DarkRoast () {
        System.out.println("Created DarkRoast");
    }
}

