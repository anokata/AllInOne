abstract class PizzaStore {
    public static void main(String[] args) {
    }

    public void orderPizza(String type) {
        Pizza pizza;
        pizza = createPizza(type);
        pizza.prepare();
        pizza.bake();
        pizza.cut();
        pizza.box();
    }

    // Метод как фабрика - фабричный метод
    abstract Pizza createPizza(String type);
}

