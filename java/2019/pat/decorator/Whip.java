class Whip extends CondimentDecorator {

    public String getDescription() { 
        return base.getDescription() + ", Whip"; 
    }

    public static void main(String[] args) {
        Beverage a = new Mocha(new Whip(new DarkRoast()));
        System.out.println(a.getDescription() + " cost:" + a.cost());
    }

    Whip (Beverage b) {
        super(b);
        condimentcost = 0.10;
        System.out.println("Created Whip");
    }
}

