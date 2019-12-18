class Whip extends CondimentDecorator {

    public double cost() {
        return 0.10 + base.cost();
    }
    public String getDescription() { 
        return base.getDescription() + ", Whip"; 
    }

    public static void main(String[] args) {
        Beverage a = new Mocha(new Whip(new DarkRoast()));
        System.out.println(a.getDescription() + " cost:" + a.cost());
    }

    Whip (Beverage b) {
        super(b);
        System.out.println("Created Whip");
    }
}

