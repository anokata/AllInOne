public class GooseFactory extends AbstractGooseFactory {
    public Quackable createGoose() {
        return new GooseAdapter(new Goose());
    }
}
