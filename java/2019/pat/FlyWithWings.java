class FlyWithWings implements FlyBehaviour {

    public void fly() {
        System.out.println("Wings!");
    }

    public static void main(String[] args) {
        FlyWithWings app = new FlyWithWings();
    }

    FlyWithWings () {
        System.out.println("Created FlyWithWings");
    }
}

