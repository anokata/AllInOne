class ChicagoStyleCheesePizza extends Pizza {
    public static void main(String[] args) {
        ChicagoStyleCheesePizza app = new ChicagoStyleCheesePizza();
    }

    ChicagoStyleCheesePizza () {
        name = "Chicago Style cheese Pizza";
        dough = "Extra Thick";
        sauce = "Plum Tomato";
        toppings.add("Mozzarella");
    }

    public void cut() {
        System.out.println("Cuttin into square");
    }
}

