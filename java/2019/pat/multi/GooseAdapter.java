class GooseAdapter implements Quackable {
    Goose goose;

    public static void main(String[] args) {
        GooseAdapter app = new GooseAdapter(new Goose());
    }

    GooseAdapter (Goose goose) {
        this.goose = goose;
    }

    public void quack() {
        goose.honk();
    }
}

