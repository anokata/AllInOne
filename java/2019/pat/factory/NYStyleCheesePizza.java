class NYStyleCheesePizza extends Pizza {
    public static void main(String[] args) {
        NYStyleCheesePizza app = new NYStyleCheesePizza();
    }

    NYStyleCheesePizza () {
        name = "NY Style cheese Pizza";
        dough = "Thin";
        sauce = "Marinara";

        toppings.add("Reggiano");
    }
}

