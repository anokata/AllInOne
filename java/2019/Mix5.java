class Mix5 {
    public static void main(String[] a) {
        int x = 0;
        int y = 30;
        for (int o = 0; o < 3; o++) {
            for (int i = 4; i > 1; i--) {
                x--;
                y = y - 2;
                //System.out.println(o + " " + i);
                System.out.println(x + " " + y);
                if (x == 6) {
                    break;
                }
                x = x + 3;
            }
            y = y - 2;
        }
        System.out.println(x + " " + y);
    }
}
