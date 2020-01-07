class WinnerState implements State {
    private static final long serialVersionUID = 6L;
    transient GumballMachine gumballMachine;

    public static void main(String[] args) {
    }

    WinnerState (GumballMachine m) {
        gumballMachine = m;
    }

    // "рано сувать"
    public void insertQuarter() {
        System.out.println("рано сувать");
    }

    // "потрачено"
    public void ejectQuarter() {
        System.out.println("потрачено");
    }

    // "уже выдаю"
    public void turnCrank() {
        System.out.println("уже выдаю");
    }

    // "удача!" выдать и >? -> SoldOutState | NoQuarterState
    public void dispense() {
        gumballMachine.releaseBall();
        if (gumballMachine.getCount() == 0) {
            gumballMachine.setState(gumballMachine.getSoldOutState());
        } else {
            System.out.println("Luck!");
            gumballMachine.releaseBall();
            if (gumballMachine.getCount() > 0) {
                gumballMachine.setState(gumballMachine.getNoQuarterState());
            } else {
                System.out.println("Oops.. out of balls");
                gumballMachine.setState(gumballMachine.getSoldOutState());
            }
        }
    }
    public void refill() { }
}

