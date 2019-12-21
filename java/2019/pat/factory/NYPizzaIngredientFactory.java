class NYPizzaIngredientFactory implements PizzaIngredientFactory {
    public static void main(String[] args) {
        NYPizzaIngredientFactory app = new NYPizzaIngredientFactory();
    }

    NYPizzaIngredientFactory () {
        System.out.println("Created NYPizzaIngredientFactory");
    }

    public Dough createDough() {
        return new ThinCrustDough();
    }

    public Sauce createSauce() {
        return new MarinaraSauce();
    }

    public Cheese createCheese() {
        return new ReggianoCheese();
    }

    public Veggies[] createVeggies() {
        Veggies veggies[] = {new Garlic(), new Onion()};
        return veggies;
    }

    public Pepperoni createPepperoni() {
        return new SlicedPepperoni();
    }

    public Clams createClam() {
        return new FreshClams();
    }

}

