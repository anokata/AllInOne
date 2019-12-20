class PizzaTest {
    public static void main(String[] args) {
        PizzaStore nyStore = new NYStylePizzaStore();
        PizzaStore chStoer = new ChicagoStylePizzaStore();

        Pizza pizza = nyStore.orderPizza("cheese");
        System.out.println("ordered:" + pizza.getName());

        pizza = chStoer.orderPizza("cheese");
        System.out.println("ordered:" + pizza.getName());
    }
}

