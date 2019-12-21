class CheesePizza extends Pizza {

    PizzaIngredientFactory ingredientFactory;

    public static void main(String[] args) {
        CheesePizza p = new CheesePizza(new NYPizzaIngredientFactory());
        p.prepare();
        p.bake();
        p.cut();
        p.box();
    }

    CheesePizza (PizzaIngredientFactory ingredientFactory) {
        this.ingredientFactory = ingredientFactory;
        System.out.println("Created CheesePizza");
    }

    public void prepare() {
        System.out.println(this.getClass() + " is preparing...");
        dough = ingredientFactory.createDough();
        sauce = ingredientFactory.createSauce();
        cheese = ingredientFactory.createCheese();
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

