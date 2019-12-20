class NYStylePizzaStore extends PizzaStore {
    public static void main(String[] args) {
        NYStylePizzaStore app = new NYStylePizzaStore();
        app.orderPizza("cheese");
    }

    NYStylePizzaStore () {
        System.out.println("Created NYStylePizzaStore");
    }

    // фабричный метод
    public Pizza createPizza(String type) {
        Pizza pizza = null;
        if (type.equals("cheese")) {
            pizza = new CheesePizza();
        }
        return pizza;
    }
}

