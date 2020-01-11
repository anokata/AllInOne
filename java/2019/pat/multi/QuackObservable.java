interface QuackObservable {
    public void registerOberser(Observer observer);
    public void notifyObservers();
}
