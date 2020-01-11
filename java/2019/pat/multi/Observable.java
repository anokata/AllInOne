import java.util.*;

class Observable implements QuackObservable {
    public static void main(String[] args) { }

    ArrayList<Observer> observers = new ArrayList<Observer>();
    QuackObservable duck;

    Observable (QuackObservable duck) {
        this.duck = duck;
    }
    
    public void registerObserver(Observer observer) {
        observers.add(observer);
    }

    public void notifyObservers() {
        Iterator iterator = observers.iterator();
        while (iterator.hasNext()) {
            Observer observer = (Observer) iterator.next();
            observer.update(duck);
        }
    }
}

