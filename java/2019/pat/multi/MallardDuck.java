class MallardDuck implements Quackable {
    Observable observable;

    public static void main(String[] args) {
        Quackable duck = new MallardDuck();
        duck.quack();
    }

    MallardDuck () {
        observable = new Observable(this);
    }

    public void quack() {
        System.out.println("Quack!");
        notifyObservers();
    }

    public void registerObserver(Observer observer) {
        observable.registerObserver(observer);
    }
    
    public void notifyObservers() {
        observable.notifyObservers();
    }
}

