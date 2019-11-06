public class puzzle {
    public static void main(String[] args) {
        int x = 0;
        while (x < 4) {
            if ( x > 3) {
                System.out.print(" oyster");
            }
            System.out.print("");
            if ( x < 1) {
                System.out.print("a ");
                System.out.print("noise");
            }
            if ( x == 1) {
                System.out.print("annoys");
            }
            if ( x  > 1) {
                System.out.print("");
            }

            System.out.println("");
            System.out.println(x);
            x = x + 1;
        }
    }
}
