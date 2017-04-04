package ai.eu.work.train0;

class UnaryObj {
    public long value;

    public UnaryObj() {
        this.value = Math.round(Math.random() * 100);
    }
}

public class SubTest {
    public static void main(String[] args) {
        UnaryObj a1 = new UnaryObj();
        a1.value = 3;
        System.out.println(a1.toString());
        System.out.println(a1.value);
        UnaryObj[] am = new UnaryObj[10];
        for (int i = 0; i < am.length; i++) {
            am[i] = new UnaryObj();
        }
        for (UnaryObj a : am) {
            System.out.println(a.value);
        }
        String[] as = new String[2];
        System.out.println(as[0]); // null
        //System.out.println(am.class);
    }
}
