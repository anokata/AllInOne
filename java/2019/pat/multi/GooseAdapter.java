class GooseAdapter implements Quackable {
    Goose goose;
    Observable observable;

    public static void main(String[] args) {
        GooseAdapter app = new GooseAdapter(new Goose());
    }

    GooseAdapter (Goose goose) {
        this.goose = goose;
        observable = new Observable(this);
    }

    public void quack() {
        goose.honk();
        notifyObservers();
    }

    public void registerObserver(Observer observer) {
        observable.registerObserver(observer);
    }
    
    public void notifyObservers() {
        observable.notifyObservers();
    }
}

