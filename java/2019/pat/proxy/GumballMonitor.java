import java.rmi.*;

class GumballMonitor {

    GumballMachineRemote machine;

    public static void main(String[] args) {
        String location = "rmi://127.0.0.1/gumballmachine";
        try {
            GumballMachineRemote m = (GumballMachineRemote) Naming.lookup(location);
            GumballMonitor mn = new GumballMonitor(m);
            System.out.println(mn);
            mn.report();
        } catch (Exception ex) { ex.printStackTrace(); }
    }

    GumballMonitor (GumballMachineRemote m) {
        machine = m;
    }

    public void report() {
        try {
            System.out.println("Gumball machine:\t " + machine.getLocation());
            System.out.println("Current inventory:\t " + machine.getCount() + " gumballs");
            System.out.println("Current state:\t\t " + machine.getState().getClass().getName());
        } catch (RemoteException ex) { ex.printStackTrace(); }
    }
}

