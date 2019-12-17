import java.util.*;

class TestNative {
    public static void main(String[] args) {
        Obj o = new Obj();
        Subj s = new Subj();
        s.addObserver(o);
        s.change();
        System.out.println("start");
        s.notifyObservers(new Integer(1));
    }

}

class Obj implements java.util.Observer {
    public void update(Observable s, Object a) {
        System.out.println("Changed:");
        System.out.println(a);
    }
}

class Subj extends java.util.Observable {
    void change() {
        setChanged();
    }
}

