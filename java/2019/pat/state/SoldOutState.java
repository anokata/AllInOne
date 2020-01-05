class SoldOutState implements State {
    public static void main(String[] args) {
        SoldOutState app = new SoldOutState();
    }

    SoldOutState () {
        System.out.println("Created SoldOutState");
    }

    // "не стоит - нет шариков"
    public void insertQuarter() {
    }

    // "нечего"
    public void ejectQuarter() {
    }

    // "нет шариков"
    public void turnCrank() {
    }

    // "кончились"
    public void dispense() {
    }
}

