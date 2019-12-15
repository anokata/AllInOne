class Silent implements QuackBehaviour {
    public static void main(String[] args) {
        Silent app = new Silent();
    }

    Silent () {
        System.out.println("Created Silent");
    }

    public void quack() {
        System.out.println("...");
    }
}

