import java.util.ArrayList;

abstract class Pizza {
    String name;
    String dough;
    String sauce;
    ArrayList<String> toppings = new ArrayList<String>();

    public static void main(String[] args) {
    }

    Pizza () {
        System.out.println("Created Pizza");
    }

    public void prepare() {
        System.out.println("Preparing " + name);
        System.out.print("Adding: ");
        for (String topping : toppings) {
            System.out.print(" " + topping);
        }
        System.out.println("");
    }
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
}

