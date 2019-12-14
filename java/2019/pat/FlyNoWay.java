class FlyNoWay implements FlyBehaviour {

    public void fly() {
        System.out.println("No Fly");
    }

    public static void main(String[] args) {
        FlyNoWay app = new FlyNoWay();
    }

    FlyNoWay () {
        System.out.println("Created FlyNoWay");
    }
}

