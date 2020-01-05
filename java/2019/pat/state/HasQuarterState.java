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
        System.out.println("нельзя всунуть ещё одну");
    }

    // Возврат и переход в NoQuarterState
    public void ejectQuarter() {
        System.out.println("returned");
        gumballMachine.setState(gumballMachine.getNoQuarterState());
    }

    // Переход в SoldState
    public void turnCrank() {
        System.out.println("You turned...");
        int winner = (int)(Math.random() * 10);
        if ((winner == 0) && (gumballMachine.getCount() > 1)) {
            gumballMachine.setState(gumballMachine.getWinnerState());
        } else {
            gumballMachine.setState(gumballMachine.getSoldState());
        }
    }

    // "сперва надо повернуть"
    public void dispense() {
        System.out.println("сперва надо повернуть");
    }
}

