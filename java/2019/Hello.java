class Hello {
    public static void main(String[] args) {
        // int types
        byte a;
        short b;
        int c;
        long d;
        // real types
        float f = 3f;
        double e = 4;
        a = 300%2;
        p("initialized " + a);
        // other primitives
        boolean flag = true;
        char sym = 'c';
        p("Hello Java world, writed in vim by memory.");
        int[] nums; // nums is link to Array of ints
        nums = new int[7]; // create Array of ints
        Sock[] socks; // array of socks
        socks = new Sock[8];
        socks[0] = new Sock("z");
        p(socks[0].name);
        if (socks[1] == null) { p("null");}
    }
    static void p(String s) {
        System.out.println(s);
    }
}

class Sock {
    String name;
    Sock(String s) {
        name = s;
    }
}
