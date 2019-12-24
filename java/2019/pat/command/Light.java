class Light {
    String name;
    public static void main(String[] args) {
        Light app = new Light("tst");
    }

    Light (String n) {
        name = n;
        System.out.println("Created Light " + name);
    }

    public void on() {
        System.out.println("Light in " + name + " is on");
    }

    public void off() {
        System.out.println("Light in " + name + " is off");
    }
}

