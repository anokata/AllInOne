class NoQuarterState implements State {
    private static final long serialVersionUID = 3L;
    transient GumballMachine gumballMachine;
    
    public static void main(String[] args) { }

    NoQuarterState (GumballMachine m) {
        this.gumballMachine = m;
    }

    // Переход в HasQuarterState
    public void insertQuarter() {
        System.out.println("You inserted a quarter coin");
        gumballMachine.setState(gumballMachine.getHasQuarterState());
    }

    // "не брожена монетка"
    public void ejectQuarter() {
        System.out.println("не брожена монетка");
    }

    // "сперва нужно бросить монетку"
    public void turnCrank() {
        System.out.println("сперва нужно бросить монетку");
    }

    // "без монеты ничего не выдаём"
    public void dispense() {
        System.out.println("без монеты ничего не выдаём");
    }
    public void refill() { }
}

