class WildTurkey implements Turkey {
    public static void main(String[] args) {
        WildTurkey app = new WildTurkey();
    }

    WildTurkey () {
        System.out.println("Created WildTurkey");
    }

    public void gobble() {
        System.out.println("guu!");
    }
    public void fly() {
        System.out.println("not so far");
    }
}

