import java.util.*;

class TestMap {
    public static void main(String[] args) {
        TestMap app = new TestMap();
    }

    TestMap () {
        System.out.println("Created TestMap");
        HashMap<String, Integer> h = new HashMap<String, Integer>();
        h.put("Some", 1);
        h.put("Where", 2);
        h.put("Over", 6);
        h.put("Rainbow", 5);
        h.put("The", 4);
        System.out.println(h);
        System.out.println(h.get("The"));
    }
}

