import java.rmi.*;
import java.rmi.server.*;

class GumballMachine extends UnicastRemoteObject implements GumballMachineRemote {
    private static final long serialVersionUID = 8L;
    State soldOutState;
    State noQuarterState;
    State hasQuarterState;
    State soldState;
    State winnerState;
    State state;
    int count = 5;

    String location;

    public static void testone() {
        try {
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
        m.refill(3);
        m.insertQuarter();
        m.turnCrank();
        } catch (Exception ex) { ex.printStackTrace(); }
    }

    public static void testrmi() {
        GumballMachine m = null;
        try {
            m = new GumballMachine("Nowhere", 4);
            Naming.rebind("//127.0.0.1/gumballmachine", m);
            //Naming.rebind("gumballmachine", m);
        } catch (Exception ex) { ex.printStackTrace(); }
    }

    public static void main(String[] args) {
        testrmi();
    }

    GumballMachine () throws RemoteException {
        this("nowhere", 5);
    }

    GumballMachine (String loc, int c) throws RemoteException {
        this.location = loc;
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

    public void refill(int c) {
        System.out.println("Заполняем");
        this.count += c;
        state.refill();
    }

    public int getCount() { return count; }
    public State getNoQuarterState() { return noQuarterState; }
    public State getHasQuarterState() { return hasQuarterState; }
    public State getSoldOutState() {return soldOutState; }
    public State getSoldState() {return soldState; }
    public State getWinnerState() {return winnerState; }

    public String getStateName() { return state.getClass().getName(); }
    public State getState() { return state; }
    public String getLocation() { return location; }
}

