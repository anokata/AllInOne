class NYStylePizzaStore extends PizzaStore {
    public static void main(String[] args) {
        NYStylePizzaStore app = new NYStylePizzaStore();
        app.orderPizza("cheese");
        app.orderPizza("clam");
    }

    NYStylePizzaStore () {
        System.out.println("Created NYStylePizzaStore");
    }

    // фабричный метод
    public Pizza createPizza(String type) {
        Pizza pizza = null;

        PizzaIngredientFactory ingredientFactory = 
            new NYPizzaIngredientFactory();

        if (type.equals("cheese")) {
            pizza = new CheesePizza(ingredientFactory);
            pizza.setName("New York Cheese");
        } else if (type.equals("clam")) {
            pizza = new ClamPizza(ingredientFactory);
            pizza.setName("NY Clam PZ");
        }
        return pizza;
    }
}

