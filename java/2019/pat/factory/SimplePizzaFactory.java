class SimplePizzaFactory {
    public static void main(String[] args) {
        SimplePizzaFactory app = new SimplePizzaFactory();
        Pizza p = app.createPizza("cheese");
        System.out.println("created: " + p.getClass());
    }

    SimplePizzaFactory () {
        System.out.println("Created SimplePizzaFactory");
    }

    public Pizza createPizza(String type) {
        Pizza pizza = null;
        if (type.equals("cheese")) {
            pizza = new CheesePizza();
        }
        return pizza;
    }
}

