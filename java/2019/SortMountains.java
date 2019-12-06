import java.util.*;

class SortMountains {

    LinkedList<Mountain> mtn = new LinkedList<Mountain>();

    class NameCompare implements Comparator<Mountain> {
        public int compare(Mountain one, Mountain two) {
            return one.getName().compareTo(two.getName());
        }
    }

    class HeightCompare implements Comparator<Mountain> {
        public int compare(Mountain one, Mountain two) {
            return two.getHeight() - one.getHeight();
        }
    }

    public static void main(String[] args) {
        new SortMountains().go();
    }

    public void go() {
        mtn.add(new Mountain("Long-Rainge", 14255));
        mtn.add(new Mountain("Elberth", 14433));
        mtn.add(new Mountain("Marun", 14156));
        mtn.add(new Mountain("Castle", 14265));

        System.out.println("In order of add:\n" + mtn);

        NameCompare nc = new NameCompare();
        Collections.sort(mtn, nc);
        System.out.println("In name order:\n" + mtn);

        HeightCompare hc = new HeightCompare();
        Collections.sort(mtn, hc);
        System.out.println("In height order:\n" + mtn);

    }

}

class Mountain {
    private String name;
    private int height;

    public String getName() {return name;}
    public int getHeight() {return height;}

    public Mountain(String n, int h) {
        name = n;
        height = h;
    }

    public String toString() {
        return name +" "+ height;
    }

}

