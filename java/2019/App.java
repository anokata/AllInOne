
public class App {
    public static void main(String[] args) {
        Dog dog;
        dog = new Dog("bobby");
        dog.setName("bill");
        System.out.println("Start App...");
        dog.bark();

        System.out.println("from Object:");
        System.out.println("dog hash:" + dog.hashCode());
        System.out.println("dog string:" + dog.toString());
        System.out.println("dog class:" + dog.getClass());

        Object o = new Object();
        System.out.println("object hash:" + o.hashCode());
        System.out.println("object string:" + o.toString());
        System.out.println("object class:" + o.getClass());
        o = dog;
        System.out.println("object hash:" + o.hashCode());
        System.out.println("object string:" + o.toString());
        System.out.println("object class:" + o.getClass());
        dog = (Dog) o; // unsafe
        if (o instanceof Dog) {
            Dog newdog = (Dog) o; // safe now
            newdog.bark();
        }
        //dog = (Dog) new Object(); // error: cannot cast

    }
}

interface Pet {
    abstract void beFriendly();
}

/* WTF?
class PetDog extends Dog implements Pet {
    public void beFriendly() {
        System.out.println("I like you");
    }
    public PetDog(String n) { }
    public PetDog() { }
}
*/
