class Lights {
    public static void main(String[] args) {
        Lights app = new Lights();
    }

    Lights () {
        System.out.println("Created Lights");
    }
    public void on() {
        System.out.println("Lights is on");
    }
    public void off() {
        System.out.println("Lights is off");
    }
    public void dim(int x) {
        System.out.println("Lights is dim to " + x);
    }
}

