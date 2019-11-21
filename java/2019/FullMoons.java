import static java.lang.System.out;
import java.util.*;
// 29.52 day  7jan2004
class FullMoons {
    static int DAY_IM = 60 * 60 * 24 * 1000;

    public static void main(String[] args) {
        Calendar c = Calendar.getInstance();
        c.set(2004,0,7,15,40);
        long day1 = c.getTimeInMillis();
        for (int x = 0; x < 3; x++) {
            day1 += (DAY_IM * 29.52);
            c.setTimeInMillis(day1);
            out.println(String.format("Полнолуние было в %tc", c));
        }
    }
}
