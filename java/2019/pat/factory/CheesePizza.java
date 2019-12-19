class CheesePizza extends Pizza {
    public static void main(String[] args) {
        CheesePizza p = new CheesePizza();
        p.prepare();
        p.bake();
        p.cut();
        p.box();
    }

    CheesePizza () {
        System.out.println("Created CheesePizza");
    }

    public void prepare() {
        System.out.println(this.getClass() + " is preparing...");
    }
    public void bake() {
        System.out.println("pizza is baking...");
    }
    public void cut() {
        System.out.println("pizza is cuting in 8 pieces...");
    }
    public void box() {
        System.out.println("pizza is boxing in a box...");
    }
}

