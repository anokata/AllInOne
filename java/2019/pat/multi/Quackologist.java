class Quackologist implements Observer {
    public static void main(String[] args) {
        Quackologist app = new Quackologist();
    }

    Quackologist () { }

    public void update(QuackObservable duck) {
        System.out.println("Quackologist: " + duck + " just quacked.");
    }
}


