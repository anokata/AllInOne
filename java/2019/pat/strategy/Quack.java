class Quack implements QuackBehaviour {
    public static void main(String[] args) {
        Quack app = new Quack();
    }

    Quack () {
        System.out.println("Created Quack");
    }

    public void quack() {
        System.out.println("Kwee!");
    }
}

