class HasQuarterState implements State {
    GumballMachine gumballMachine;

    public static void main(String[] args) {
        HasQuarterState app = new HasQuarterState(new GumballMachine());
    }

    HasQuarterState (GumballMachine m) {
        this.gumballMachine = m;
    }

    // "нельзя всунуть ещё одну"
    public void insertQuarter() {
    }

    // Возврат и переход в NoQuarterState
    public void ejectQuarter() {
    }

    // Переход в SoldState
    public void turnCrank() {
    }

    // "сперва надо повернуть"
    public void dispense() {
    }
}

