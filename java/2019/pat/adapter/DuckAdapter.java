class DuckAdapter implements Turkey {
    Duck duck;

    public static void main(String[] args) {
        Duck d = new MallardDuck();
        Turkey duckAsTurkey = new DuckAdapter(d);
        testTurkey(duckAsTurkey);
    }

    public static void testTurkey(Turkey t) {
        t.gobble();
        t.fly();
    }
    // 277

    DuckAdapter (Duck duck) {
        this.duck = duck;
        System.out.println("Created DuckAdapter");
    }

    public void gobble() {
        duck.quack();
    }

    public void fly() {
        duck.fly();
    }
}

