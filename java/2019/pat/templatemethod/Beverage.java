abstract class Beverage {
    public static void main(String[] args) { }

    Beverage () {
        System.out.println("Created Beverage");
    }

    public void boilWater() {
        System.out.println("Boiling water");
    }

    public void pourInCup() {
        System.out.println("Pouring Into Cup");
    }

    public abstract void brew();
    public abstract void addCondiments();

    // Template Method
    final public void prepareRecipe() {
        boilWater();
        brew();
        pourInCup();
        addCondiments();
    }
}

