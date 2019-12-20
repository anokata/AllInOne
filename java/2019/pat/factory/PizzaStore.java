abstract class PizzaStore {
    public static void main(String[] args) {
    }

    public Pizza orderPizza(String type) {
        Pizza pizza;
        pizza = createPizza(type);
        pizza.prepare();
        pizza.bake();
        pizza.cut();
        pizza.box();
        return pizza;
    }

    // Метод как фабрика - фабричный метод
    abstract Pizza createPizza(String type);
}

