class Mocha extends CondimentDecorator {
    public int cost() {
        return 5 + base.cost();
    }
    public static void main(String[] args) {
    }

    Mocha(Beverage b) {
        super(b);
    }
}
