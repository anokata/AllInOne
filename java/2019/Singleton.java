// Pattern #1
public class Singleton {
    protected Singleton() {
    }

    private static Singleton instance;

    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }

    public static void main(String[] args) {
        // test
        Singleton s = Singleton.getInstance();
        Singleton t = Singleton.getInstance();
        System.out.println(s==t);
        //Aloner a = Aloner.getInstance();
    }
}

class Aloner extends Singleton {
    private Aloner() {}
}
