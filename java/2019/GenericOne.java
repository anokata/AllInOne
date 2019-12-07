import java.util.*;

class GenericOne {
    public static void main(String[] args) {
        GenericOne app = new GenericOne();
    }

    GenericOne () {
        System.out.println("Created GenericOne");
        Creature[] creaturesArray = {new Creature(), new Man(), new Pet()};
        viewArray(creaturesArray);

        ArrayList<Creature> ac = new ArrayList<Creature>();
        //ArrayList<Creature> ac = new ArrayList<Homo>(); // NOT
        ac.add(new Homo());
        ac.add(new Man());
        viewAList(ac);

        //ArrayList<Homo> ah = new ArrayList<Creature>(); // NOT
        List<Creature> lc = new ArrayList<Creature>();
        ArrayList<Homo> ah = new ArrayList<Homo>();
        // ac = ah; NOT
        lc = ac;

        ah.add(new Homo());
        ah.add(new Man());
        viewHList(ah);
        // viewAList(ah); NOT
    }

    void viewArray(Creature[] a) {
        for (Creature x : a) { x.eat(); }
    }

    void viewAList(ArrayList<Creature> l) {
        for (Creature x : l) { x.eat(); }
    }

    <T extends Homo> void viewHList(ArrayList<T> l) {
        for (T x : l) { x.eat(); }
    }

}

class Creature {
    public void eat() { System.out.println(this.getClass() + " eat"); }
}

class Homo extends Creature {
}

class Man extends Homo {
}

class Pet extends Creature {
}
