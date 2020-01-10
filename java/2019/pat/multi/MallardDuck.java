class MallardDuck implements Quackable {
    public static void main(String[] args) {
        Quackable duck = new MallardDuck();
        duck.quack();
    }

    MallardDuck () {
    }

    public void quack() {
        System.out.println("Quack!");
    }
}

