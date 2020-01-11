import java.util.*;

class Observable implements QuackObservable {
    public static void main(String[] args) { }

    ArrayList<Observer> observers = new ArrayList<Observer>();
    QuackObservable duck;

    Observable (QuackObservable duck) {
        this.duck = duck;
    }
}

