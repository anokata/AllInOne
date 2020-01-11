class DuckSimulator {
    public static void main(String[] args) {
        new DuckSimulator().simulate(new CountingDuckFactory(), new GooseFactory());
    }

    DuckSimulator () {
    }

    void simulate(AbstractDuckFactory duckFactory, AbstractGooseFactory gooseFactory) {
        Quackable mallardDuck = duckFactory.createMallardDuck();
        Quackable readheadDuck = duckFactory.createReadheadDuck();
        Quackable duckCall = duckFactory.createDuckCall();
        Quackable rubberDuck = duckFactory.createRubberDuck();
        Quackable goose = gooseFactory.createGoose();

        Flock flockOfDucks = new Flock();
        flockOfDucks.add(readheadDuck);
        flockOfDucks.add(duckCall);
        flockOfDucks.add(rubberDuck);
        flockOfDucks.add(goose);

        Flock flockOfMallard = new Flock();
        flockOfMallard.add(mallardDuck);
        flockOfMallard.add(duckFactory.createMallardDuck());
        flockOfMallard.add(duckFactory.createMallardDuck());
        flockOfMallard.add(duckFactory.createMallardDuck());
        flockOfDucks.add(flockOfMallard);

        System.out.println("(Duck Simulator)");
        simulate(flockOfDucks);

        System.out.println("Quacks: " + QuackCounter.getQuacks());

        System.out.println("(Duck Simulator)");
        simulate(flockOfMallard);
        System.out.println("Quacks: " + QuackCounter.getQuacks());
    }

    public void simulate(Quackable d) {
        d.quack();
    }
}

