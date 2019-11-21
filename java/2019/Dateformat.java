import java.util.*;

class Dateformat {
    public static void main(String[] args) {
        Date d = new Date();
        System.out.println(d);
        System.out.println(String.format("%tc", d));
        System.out.println(String.format("%tr", d));
        System.out.println(String.format("%td %tb %ta", d, d, d));
        System.out.println(String.format("%td %<tb %<tr", d));

        Calendar cal = Calendar.getInstance();
        System.out.println(cal.getClass());
        System.out.println(cal.getTime());
        cal.set(1988, 10, 29);
        System.out.println(cal.getTime());
        cal.add(cal.YEAR, 70);
        System.out.println(cal.getTime());

        cal = Calendar.getInstance();
        System.out.println(String.format("%tH:%<tM", cal.getTime()));
        cal.add(cal.HOUR, 1);
        System.out.println(String.format("%tH:%<tM", cal.getTime()));
        cal.add(cal.MINUTE, 10);
        System.out.println(String.format("%tH:%<tM", cal.getTime()));


    }
}
