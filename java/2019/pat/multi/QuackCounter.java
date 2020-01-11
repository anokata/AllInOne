// Duck decorator
class QuackCounter implements Quackable { 
    Quackable duck;
    static int numbersOfQuacks;

    public static void main(String[] args) {
        QuackCounter app = new QuackCounter(new MallardDuck());
    }

    QuackCounter (Quackable duck) {
        this.duck = duck;
    }
    
    public void quack() { 
        numbersOfQuacks++;
        this.duck.quack(); 
    }

    public static int getQuacks() { return numbersOfQuacks; }

    public void registerObserver(Observer observer) {
        duck.registerObserver(observer);
    }
    
    public void notifyObservers() {
        duck.notifyObservers();
    }
}

