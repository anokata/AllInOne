class Duck {

    FlyBehaviour flyer = new FlyNoWay();
    QuackBehaviour quacker;

    public static void main(String[] args) {
        Duck app = new Duck();
    }

    Duck () {
        System.out.println("Created Duck");
    }
}

