class DuckCall implements Quackable {
    Observable observable;

    public static void main(String[] args) {
        DuckCall app = new DuckCall();
    }

    DuckCall () {
        observable = new Observable(this);
    }

    public void quack() {
        System.out.println("Kwak");
        notifyObservers();
    }

    public void registerObserver(Observer observer) {
        observable.registerObserver(observer);
    }
    
    public void notifyObservers() {
        observable.notifyObservers();
    }
}

