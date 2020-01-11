class ReadheadDuck implements Quackable {
    Observable observable;

    public static void main(String[] args) {
        ReadheadDuck d = new ReadheadDuck();
    }

    ReadheadDuck () {
        observable = new Observable(this);
    }

    public void quack() {
        System.out.println("Quack");
        notifyObservers();
    }

    public void registerObserver(Observer observer) {
        observable.registerObserver(observer);
    }
    
    public void notifyObservers() {
        observable.notifyObservers();
    }
}

