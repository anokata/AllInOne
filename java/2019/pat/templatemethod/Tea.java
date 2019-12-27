class Tea extends Beverage {
    public static void main(String[] args) {
        Tea app = new Tea();
    }

    Tea () {
        System.out.println("Created Tea");
    }

    public void brew() {
        System.out.println("Diping teabag");
    }

    public void addCondiments() {
        System.out.println("Add lemon");
    }
}

