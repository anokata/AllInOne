class SoldOutState implements State {
    GumballMachine gumballMachine;

    public static void main(String[] args) {
    }

    SoldOutState (GumballMachine m) {
        this.gumballMachine = m;
    }

    // "не стоит - нет шариков"
    public void insertQuarter() {
        System.out.println("не стоит - нет шариков");
    }

    // "нечего"
    public void ejectQuarter() {
        System.out.println("нечего");
    }

    // "нет шариков"
    public void turnCrank() {
        System.out.println("нет шариков");
    }

    // "кончились"
    public void dispense() {
        System.out.println("кончились");
    }
}

