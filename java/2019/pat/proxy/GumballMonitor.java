class GumballMonitor {

    GumballMachine machine;

    public static void main(String[] args) {
        GumballMonitor mn = new GumballMonitor(new GumballMachine());
        mn.report();
    }

    GumballMonitor (GumballMachine m) {
        machine = m;
    }

    public void report() {
        System.out.println("Gumball machine:\t " + machine.getLocation());
        System.out.println("Current inventory:\t " + machine.getCount() + " gumballs");
        System.out.println("Current state:\t\t " + machine.getStateName());
    }
}

