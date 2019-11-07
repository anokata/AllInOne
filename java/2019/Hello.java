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
    }
    static void p(String s) {
        System.out.println(s);
    }
}
