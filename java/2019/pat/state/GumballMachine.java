class GumballMachine {
    State soldOutState;
    State noQuarterState;
    State hasQuarterState;
    State soldState;
    State winnerState;
    State state;
    int count = 5;

    public static void main(String[] args) {
        GumballMachine m = new GumballMachine();
        m.insertQuarter();
        m.ejectQuarter();
        m.insertQuarter();
        m.turnCrank();
        System.out.println("balls: " + m.count + " in " + m.state.getClass().getName());
        m.insertQuarter();
        m.turnCrank();
        m.insertQuarter();
        m.turnCrank();
        m.insertQuarter();
        m.turnCrank();
        m.insertQuarter();
        m.turnCrank();
        m.insertQuarter();
        m.turnCrank();
        m.insertQuarter();
        m.turnCrank();
        m.insertQuarter();
        m.turnCrank();
    }

    GumballMachine () {
        this(5);
    }

    GumballMachine (int c) {
        this.count = c;
        soldOutState = new SoldOutState(this);
        noQuarterState = new NoQuarterState(this);
        hasQuarterState = new HasQuarterState(this);
        soldState = new SoldState(this);
        winnerState = new WinnerState(this);
        if (c > 0) {
            state = noQuarterState;
        } else {
            state = soldOutState;
        }
    }


    public void setState(State s) {
        this.state = s;
    }

    public void insertQuarter() {
        state.insertQuarter();
    }

    public void ejectQuarter() {
        state.ejectQuarter();
    }

    public void turnCrank() {
        state.turnCrank();
        state.dispense();
    }

    public void releaseBall() {
        System.out.println("A gumball comes rolling...");
        if (count != 0) {
            count--;
        }
    }

    public int getCount() { return count; }
    public State getNoQuarterState() { return noQuarterState; }
    public State getHasQuarterState() { return hasQuarterState; }
    public State getSoldOutState() {return soldOutState; }
    public State getSoldState() {return soldState; }
    public State getWinnerState() {return winnerState; }
}

