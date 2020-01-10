class DuckSimulator {
    public static void main(String[] args) {
        new DuckSimulator().simulate();
    }

    DuckSimulator () {
    }

    void simulate() {
        Quackable mallardDuck = new QuackCounter(new MallardDuck());
        Quackable readheadDuck = new QuackCounter(new ReadheadDuck());
        Quackable duckCall = new QuackCounter(new DuckCall());
        Quackable rubberDuck = new QuackCounter(new RubberDuck());
        Quackable goose = (new GooseAdapter(new Goose()));

        System.out.println("(Duck Simulator)");

        simulate(mallardDuck);
        simulate(readheadDuck);
        simulate(duckCall);
        simulate(rubberDuck);
        simulate(goose);

        System.out.println("Quacks: " + QuackCounter.getQuacks());
    }

    public void simulate(Quackable d) {
        d.quack();
    }
}

