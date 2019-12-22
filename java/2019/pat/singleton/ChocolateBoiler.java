class ChocolateBoiler {
    private boolean empty;
    private boolean boiled;
    private static ChocolateBoiler instance;

    public static void main(String[] args) {
        ChocolateBoiler a = ChocolateBoiler.getInstance();
        new Thread(() -> {
               ChocolateBoiler b = ChocolateBoiler.getInstance();
               b.fill(); 
        }).start();
        a.fill();
        a.boil();
        a.drain();
    }

    private ChocolateBoiler () {
        System.out.println("Created ChocolateBoiler");
        empty = true;
        boiled = false;
    }

    public static synchronized ChocolateBoiler getInstance() {
        if (instance == null) {
            instance = new ChocolateBoiler();
        }
        return instance;
    }

    public void prn() {
        boolean ok = !(isEmpty() && isBoiled());
        System.out.println("empty: " + empty + " boiled: " + boiled + " ok:" + ok);
    }
    public void prn(String msg) {
        boolean ok = !(isEmpty() && isBoiled());
        System.out.println("empty: " + empty + " boiled: " + boiled + " ok:" + ok + " " + msg);
    }

    public void fill() {
        if (isEmpty()) {
            empty = false;
            boiled = false;
            prn("fill");
        }
    }

    public boolean isEmpty() { return empty; }
    public boolean isBoiled() { return boiled; }

    public void drain() {
        if (!isEmpty() && isBoiled()) {
            empty = true;
            prn();
        }
    }

    public void boil() {
        if (!isEmpty() && !isBoiled()) {
            boiled = true;
            prn();
        }
    }
}

