class Soy extends CondimentDecorator {
    public String getDescription() { 
        return base.getDescription() + ", Soy"; 
    }

    public double cost() {
        return 0.15 + base.cost();
    }
    public static void main(String[] args) {
    }

    Soy(Beverage b) {
        super(b);
    }
}

