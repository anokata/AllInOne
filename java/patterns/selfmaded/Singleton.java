
class IsSingle {

    public static int counter = 0; // for test

    /*
     * instance store field
     */
    private static IsSingle instance;

    /*
     * private constructor 
     */
    private IsSingle() {
        counter++; // for testing purpose
    }

    /*
     * getter for single instance.
     * create alone instance.
     */
    public static IsSingle get() {
        if (instance == null) {
            instance = new IsSingle();
        }
        return instance;
    }
}

public class Singleton {
    public static void main(String[] args) {
        System.out.println("instances " + IsSingle.counter);
        IsSingle x = IsSingle.get();
        IsSingle y = IsSingle.get();
        x = IsSingle.get();
        y = IsSingle.get();
        System.out.println("instances " + IsSingle.counter);
    }
}
