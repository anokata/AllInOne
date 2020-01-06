class SoldState implements State {
    GumballMachine gumballMachine;

    public static void main(String[] args) {
    }

    SoldState (GumballMachine m) {
        this.gumballMachine = m;
    }

    // "подождите выдачи"
    public void insertQuarter() {
        System.out.println("подождите выдачи");
    }

    // "нельзя вернуть, потрачено"
    public void ejectQuarter() {
        System.out.println("нельзя вернуть, потрачено");
    }

    // "уже выдаётся"
    public void turnCrank() {
        System.out.println("уже выдаётся");
    }

    // выдать, >0? перейти NoQuarterState или SoldOutState
    public void dispense() {
        System.out.println("dispensing");
        gumballMachine.releaseBall();
        if (gumballMachine.getCount() > 0) {
            gumballMachine.setState(gumballMachine.getNoQuarterState());
        } else {
            System.out.println("Oops.. out of balls");
            gumballMachine.setState(gumballMachine.getSoldOutState());
        }
    }
    public void refill() { }
}

