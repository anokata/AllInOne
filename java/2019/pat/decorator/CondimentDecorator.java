abstract class CondimentDecorator extends Beverage {
    Beverage base;
    public abstract String getDescription();
    double condimentcost = 0.01;

    public double cost() {
        double factor = getFactor();
        return factor * condimentcost + base.cost();
    }

    public double getFactor() {
        double factor = 1.0;
        switch (this.getSize()) {
            case TALL: factor = 1.5;
            case GRANDE: factor = 2.0;
        }
        return factor;
    }

    public static void main(String[] args) {
    }

    CondimentDecorator (Beverage b) {
        base = b;
    }
}

