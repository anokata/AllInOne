class Whip extends CondimentDecorator {

    public int cost() {
        return 10 + base.cost();
    }

    public static void main(String[] args) {
        Beverage a = new Mocha(new Whip(new DarkRoast()));
        System.out.println("cost:" + a.cost());
    }

    Whip (Beverage b) {
        super(b);
        System.out.println("Created Whip");
    }
}

