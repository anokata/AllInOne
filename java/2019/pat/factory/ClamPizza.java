public class ClamPizza extends Pizza {
    PizzaIngredientFactory ingredientFactory;

    public ClamPizza(PizzaIngredientFactory ingredientFactory) {
        this.ingredientFactory = ingredientFactory;
    }

    public void prepare() {
        System.out.println("Prepare " + name);
        dough = ingredientFactory.createDough();
        sauce = ingredientFactory.createSauce();
        cheese = ingredientFactory.createCheese();
        clam = ingredientFactory.createClam();
    }

    public static void main(String[] args) {
        ClamPizza p = new ClamPizza(new NYPizzaIngredientFactory());
        p.prepare();
        p.bake();
        p.cut();
        p.box();
    }

}
