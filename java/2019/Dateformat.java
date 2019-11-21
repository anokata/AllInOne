import java.util.*;
import static java.lang.Math.*;
import static java.lang.System.out;

class Dateformat {
    public static void main(String[] args) {
        Date d = new Date();
        out.println(d);
        out.println(String.format("%tc", d));
        out.println(String.format("%tr", d));
        out.println(String.format("%td %tb %ta", d, d, d));
        out.println(String.format("%td %<tb %<tr", d));

        Calendar cal = Calendar.getInstance();
        out.println(cal.getClass());
        out.println(cal.getTime());
        cal.set(1988, 10, 29);
        out.println(cal.getTime());
        cal.add(cal.YEAR, 70);
        out.println(cal.getTime());

        cal = Calendar.getInstance();
        out.println(String.format("%tH:%<tM", cal.getTime()));
        cal.add(cal.HOUR, 1);
        out.println(String.format("%tH:%<tM", cal.getTime()));
        cal.add(cal.MINUTE, 10);
        out.println(String.format("%tH:%<tM", cal.getTime()));
        out.println(String.format("%.1f", sin(123)));


    }
}
