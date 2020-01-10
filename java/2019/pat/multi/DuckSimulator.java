class DuckSimulator {
    public static void main(String[] args) {
        new DuckSimulator().simulate();
    }

    DuckSimulator () {
    }

    void simulate() {
        Quackable mallardDuck = new MallardDuck();
        Quackable readheadDuck = new ReadheadDuck();
        Quackable duckCall = new DuckCall();
        Quackable rubberDuck = new RubberDuck();
        Quackable goose = new GooseAdapter(new Goose());

        System.out.println("(Duck Simulator)");

        simulate(mallardDuck);
        simulate(readheadDuck);
        simulate(duckCall);
        simulate(rubberDuck);
        simulate(goose);
    }

    public void simulate(Quackable d) {
        d.quack();
    }
}

