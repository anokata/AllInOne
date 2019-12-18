abstract class CondimentDecorator extends Beverage {
    Beverage base;

    public static void main(String[] args) {
    }

    CondimentDecorator (Beverage b) {
        base = b;
    }
}

