import java.util.ArrayList;

abstract class Pizza {
    String name;
    Dough dough;
    Sauce sauce;
    Veggies veggies[];
    Cheese cheese;
    Pepperoni pepperoni;
    Clams clam;

    public static void main(String[] args) {
    }

    Pizza () {
        System.out.println("Created Pizza");
    }

    public abstract void prepare();
    public void bake() {
        System.out.println("Bake for 25 minutes at 350");
    }

    public void cut() {
        System.out.println("Cutting");
    }

    public void box() {
        System.out.println("Place in box");
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String toString() {
        return name + " pizza";
    }
}

