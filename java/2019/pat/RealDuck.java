class RealDuck extends Duck {
    FlyBehaviour flyer = new FlyWithWings();

    public static void main(String[] args) {
        RealDuck app = new RealDuck();
    }

    RealDuck () {
        System.out.println("Created RealDuck");
        flyer.fly();
    }
}

