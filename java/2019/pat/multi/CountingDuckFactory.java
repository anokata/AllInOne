class CountingDuckFactory extends AbstractDuckFactory {
    public static void main(String[] args) {
        CountingDuckFactory app = new CountingDuckFactory();
    }

    public Quackable createMallardDuck() {
        return new QuackCounter(new MallardDuck());
    }

    public Quackable createReadheadDuck() {
        return new QuackCounter(new ReadheadDuck());
    }

    public Quackable createDuckCall() {
        return new QuackCounter(new DuckCall());
    }

    public Quackable createRubberDuck() {
        return new QuackCounter(new RubberDuck());
    }

}


