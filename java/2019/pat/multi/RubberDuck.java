class RubberDuck implements Quackable {
    Observable observable;

    public static void main(String[] args) {
        RubberDuck app = new RubberDuck();
    }

    RubberDuck () {
        observable = new Observable(this);
    }

    public void quack() {
        System.out.println("Squek");
        notifyObservers();
    }

    public void registerObserver(Observer observer) {
        observable.registerObserver(observer);
    }
    
    public void notifyObservers() {
        observable.notifyObservers();
    }
}

