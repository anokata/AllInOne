class TurkeyAdapter implements Duck {
    Turkey turkey;

    public static void main(String[] args) {
        Turkey testBird = new WildTurkey();
        Duck turkeyAsDuck = new TurkeyAdapter(testBird);
        testDuck(turkeyAsDuck);
    }

    public static void testDuck(Duck d) {
        d.fly();
        d.quack();
    }

    TurkeyAdapter (Turkey turkey) {
        this.turkey = turkey;
        System.out.println("Created TurkeyAdapter");
    }

    public void quack() {
        turkey.gobble();
    }

    public void fly() {
        for (int i=0; i<5; i++) {
            turkey.fly();
        }
    }
}

