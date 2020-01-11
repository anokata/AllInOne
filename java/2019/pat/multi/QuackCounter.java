// Duck decorator
class QuackCounter implements Quackable { 
    Quackable duck;
    static int numbersOfQuacks;
    Observable observable;

    public static void main(String[] args) {
        QuackCounter app = new QuackCounter(new MallardDuck());
    }

    QuackCounter (Quackable duck) {
        this.duck = duck;
        observable = new Observable(this);
    }
    
    public void quack() { 
        numbersOfQuacks++;
        this.duck.quack(); 
    }

    public static int getQuacks() { return numbersOfQuacks; }

    public void registerObserver(Observer observer) {
        observable.registerObserver(observer);
    }
    
    public void notifyObservers() {
        observable.notifyObservers();
    }
}

