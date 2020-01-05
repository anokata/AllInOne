class GumballMachine {
    State soldOutState;
    State noQuarterState;
    State hasQuarterState;
    State soldState;
    State state;
    int count = 5;

    public static void main(String[] args) {
        GumballMachine app = new GumballMachine();
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
        if (c > 0) {
            state = noQuarterState;
        } else {
            state = soldOutState;
        }
    }

    public State getHasQuarterState() {
        return new HasQuarterState(this);
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
    }
}

