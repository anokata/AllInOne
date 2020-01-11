class DuckFactory extends AbstractDuckFactory {
    public static void main(String[] args) {
        DuckFactory app = new DuckFactory();
    }

    public Quackable createMallardDuck() {
        return new MallardDuck();
    }

    public Quackable createReadheadDuck() {
        return new ReadheadDuck();
    }

    public Quackable createDuckCall() {
        return new DuckCall();
    }

    public Quackable createRubberDuck() {
        return new RubberDuck();
    }

}

