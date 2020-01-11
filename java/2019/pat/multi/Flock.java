import java.util.*;
import java.util.Iterator;

class Flock implements Quackable {
    ArrayList<Quackable> quackers = new ArrayList<Quackable>();

    public void add(Quackable quacker) {
        quackers.add(quacker);
    }

    public void quack() {
        Iterator<Quackable> iterator = quackers.iterator();
        while (iterator.hasNext()) {
            Quackable quacker = iterator.next();
            quacker.quack();
        }
    }

    public static void main(String[] args) {
        Flock f = new Flock();
        f.add(new CountingDuckFactory().createMallardDuck());
        f.add(new GooseFactory().createGoose());
        f.quack();
    }
}
