abstract class Pizza {
    public static void main(String[] args) {
    }

    Pizza () {
        System.out.println("Created Pizza");
    }

    public abstract void prepare();
    public abstract void bake();
    public abstract void cut();
    public abstract void box();
}

