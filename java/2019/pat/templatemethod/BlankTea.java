class BlankTea extends Beverage {
    public static void main(String[] args) {
        BlankTea app = new BlankTea();
    }

    BlankTea () {
        System.out.println("Created BlankTea");
    }

    public void brew() {
        System.out.println("Diping teabag");
    }

    public void addCondiments() {
        System.out.println("no");
    }

    public boolean needCondiments() { return false; } // redefine Hook!
}


