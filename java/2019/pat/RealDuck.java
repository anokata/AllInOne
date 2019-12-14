class RealDuck extends Duck {

    public static void main(String[] args) {
        RealDuck app = new RealDuck();
    }

    RealDuck () {
        setFly(new FlyWithWings());
        System.out.println("Created RealDuck");
        performFly();
    }
}

