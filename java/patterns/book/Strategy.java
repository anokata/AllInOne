public class Strategy {
    public static void main(String[] args) {
        Duck d = new NormalDuck();
        d.display();
        d.fly();
        d.quack();
        d.swim();
        d = new ModelDuck();
        d.display();
        d.fly();
        d.quack();
        d.swim();
        d.setFlyBehavior(new FlyWithRocket());
        d.fly();
    }
}

interface FlyBehavior {
    void fly();
}

class FlyWithWings implements FlyBehavior {
    public void fly() {
        System.out.println("Wings fly");
    }
}

class FlyNo implements FlyBehavior {
    public void fly() {
        System.out.println("Can't fly");
    }
}

class FlyWithRocket implements FlyBehavior {
    public void fly() {
        System.out.println("ROCKET fly");
    }
}

interface QuackBehavior {
    void quack();
}

class Kuack implements QuackBehavior {
    public void quack() {
        System.out.println("Kuack!");
    }
}

class MuteQuack implements QuackBehavior {
    public void quack() {
        System.out.println("...");
    }
}

abstract class Duck {

    FlyBehavior fb;
    QuackBehavior qb;

    public void swim() {
        System.out.println("Swiming * ");
    }

    public void display() {}

    public void fly() {
        fb.fly();
    }

    public void quack() {
        qb.quack();
    }

    public void setFlyBehavior(FlyBehavior fb) {
        this.fb = fb;
    }

    public void setQuackBehavior(QuackBehavior qb) {
        this.qb = qb;
    }
}

class NormalDuck extends Duck {

    public void display() {
        System.out.println("* Normal Duck");
    }

    public NormalDuck() {
        fb = new FlyWithWings();
        qb = new Kuack();
    }

}

class ModelDuck extends Duck {

    public void display() {
        System.out.println("* Model Duck");
    }

    public ModelDuck() {
        fb = new FlyNo();
        qb = new MuteQuack();
    }

}
