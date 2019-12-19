class PizzaStore {
    public static void main(String[] args) {
        PizzaStore app = new PizzaStore();
        app.orderPizza("cheese");
    }
    SimplePizzaFactory factory = new SimplePizzaFactory();

    public void orderPizza(String type) {
        Pizza pizza;
        pizza = factory.createPizza(type);
        pizza.prepare();
        pizza.bake();
        pizza.cut();
        pizza.box();
    }
}

