
interface AnonI {
    int a = 3;
}

class anonim {
    public static void main(String[] args) {
        AnonI a = new AnonI() {
            public int a = 8;
        };
        System.out.println("anon new field " + a.a);
    }
}
