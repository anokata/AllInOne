class MallardDuck implements Duck {
    public static void main(String[] args) {
        MallardDuck app = new MallardDuck();
    }

    MallardDuck () {
        System.out.println("Created MallardDuck");
    }
    public void quack() {
        System.out.println("Qwee!");
    }
    public void fly() {
        System.out.println("Whouu!");
    }
}

