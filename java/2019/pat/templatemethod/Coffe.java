class Coffe extends Beverage {
    public static void main(String[] args) {
        Coffe cup = new Coffe();
        cup.prepareRecipe();
    }

    Coffe () {
        System.out.println("Created Coffe");
    }

    public void brew() {
        System.out.println("Filer");
    }

    public void addCondiments() {
        System.out.println("Add milk");
    }
}

