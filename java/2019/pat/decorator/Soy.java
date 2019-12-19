class Soy extends CondimentDecorator {
    public String getDescription() { 
        return base.getDescription() + ", Soy"; 
    }

    public static void main(String[] args) {
    }

    Soy(Beverage b) {
        super(b);
        condimentcost = 0.15;
    }
}

