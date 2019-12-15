class Duck {

    FlyBehaviour flyer = new FlyNoWay();
    QuackBehaviour quacker = new Silent();

    public static void main(String[] args) {
        Duck app = new Duck();
    }

    Duck () {
       System.out.println("Created Duck");
       performFly();
       performQuack();
    }
    
    void setFly(FlyBehaviour f) {
        flyer = f;
    }

    void performFly() {
        flyer.fly();
    }
    void performQuack() {
        quacker.quack();
    }
}

