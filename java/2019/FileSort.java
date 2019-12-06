import java.util.*;
import java.io.*;

class FileSort {
    public static void main(String[] args) {
        FileSort app = new FileSort();
    }

    ArrayList<Song> list = new ArrayList<Song>();

    FileSort () {
        File file = new File("testfile");
        try {
            String line;
            BufferedReader in = new BufferedReader(new FileReader(file));
            while ((line = in.readLine()) != null) {
                list.add(makeSong(line));
            }
        } catch (Exception ex) { ex.printStackTrace(); }
        System.out.println(list);
        Collections.sort(list);
        System.out.println(list);
        Collections.sort(list, new SongCompareRating());
        System.out.println(list);

        HashSet<Song> songSet = new HashSet<Song>();
        songSet.addAll(list);
        System.out.println(songSet);

        TreeSet<Song> songTree = new TreeSet<Song>();
        songTree.addAll(list);
        songTree.add(new Song("A", "b", "0", "1"));
        System.out.println(songTree);

    }

    Song makeSong(String s) {
        String[] songParts = s.split("/");
        return new Song(songParts[0], songParts[1], songParts[2], songParts[3]);
    }
}

class SongCompareRating implements Comparator<Song> {
    public int compare(Song s, Song t) {
        return s.getRating() - t.getRating();
    }
}

class Song implements Comparable<Song> {
    String title;
    String artist;
    String rating;
    String bpm;

    Song(String t, String a, String r, String b) {
        title = t;
        artist = a;
        rating = r;
        bpm = b;
    }

    public String getTitle() {return title;}
    public int getRating() {return Integer.parseInt(rating);}

    public int compareTo(Song s) {
        return title.compareTo(s.getTitle());
    }

    public <T extends Song> T getme(T s) {
        return s;
    }

    public String toString() {
        return title + " -- " + artist + "(" + rating + ")";
    }
    
    public int hashCode() {
        //return toString().hashCode();
        return title.hashCode();
    }

    public boolean equals(Object o) {
        if (o instanceof Song) {
            Song s = (Song) o;
            return s.title.equals(title);
        }
        return false;
    }

    // TODO Что если в хеш сет добавить несколько объектов с одним hash но разные и потом извлчечь по хешу?
}
