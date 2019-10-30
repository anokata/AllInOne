public class Beer {
    public static void main(String[] args) {
        Bottles bottles = new Bottles(3);
        while (bottles.isMore()) {
            System.out.print(bottles.takeOne());
        }
    }
}

class Bottles {
    public static String linebeer = " bottles of beer ";
    public static String linewall = " on the wall";
    public static String linetake = "Take one down, pass it around";
    public static String lineno   = "No more bottles of beer on the wall, no more bottles of beer.";
    private int count;

    public Bottles(int count) {
        this.count = count;
    }

    private String formatLine(String line) {
        return line + "\n";
    }

    public String takeOne() {
        count--;
        if (count == 0) {
            return lineno;
        }
        String beer;
        beer = formatLine(count + linebeer + linewall);
        beer += formatLine(linetake);
        return beer;
    }

    public Boolean isMore() {
        return count > 0;
    }
}
