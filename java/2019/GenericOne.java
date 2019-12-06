import java.util.*;

class GenericOne {
    public static void main(String[] args) {
        GenericOne app = new GenericOne();
    }

    GenericOne () {
        System.out.println("Created GenericOne");
        Creature[] creaturesArray = {new Creature(), new Man(), new Pet()};
        viewArray(creaturesArray);


    }

    void viewArray(Creature[] a) {
        for (Creature x : a) { x.eat(); }
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
