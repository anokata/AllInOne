class Mocha extends CondimentDecorator {
    public String getDescription() { 
        return base.getDescription() + ", Mocha"; 
    }

    public static void main(String[] args) {
    }

    Mocha(Beverage b) {
        super(b);
        condimentcost = 0.20;
    }
}
