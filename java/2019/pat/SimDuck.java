class SimDuck extends Duck {
    FlyBehaviour flyer = new FlyNoWay();

    public static void main(String[] args) {
        SimDuck app = new SimDuck();
    }

    SimDuck () {
        System.out.println("Created SimDuck");
        flyer.fly();
        performQuack();
    }
}

