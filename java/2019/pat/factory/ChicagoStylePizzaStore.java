class ChicagoStylePizzaStore extends PizzaStore {
    public static void main(String[] args) {
        ChicagoStylePizzaStore app = new ChicagoStylePizzaStore();
        app.orderPizza("cheese");
    }

    ChicagoStylePizzaStore () {
        System.out.println("Created ChicagoStylePizzaStore");
    }

    // фабричный метод
    public Pizza createPizza(String type) {
        Pizza pizza = null;
        if (type.equals("cheese")) {
            pizza = new ChicagoStyleCheesePizza();
        }
        return pizza;
    }
}


