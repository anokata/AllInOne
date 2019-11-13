import java.util.ArrayList;

class DotCom {
    private ArrayList<String> locationCells;
    private String name;

    public void setName(String n) {
        name = n;
    }

    public String checkYourself(String userInput) {
        String result = "Miss";
        int index = locationCells.indexOf(userInput);
        if (index >= 0) {
            locationCells.remove(index);
            if (locationCells.isEmpty()) {
                result = "Ruined";
                System.out.println("Ruin " + name);
            } else {
                result = "Hit";
            }
        }

        return result;
    }

    public void setLocationCells(ArrayList<String> loc){
        locationCells = loc;
    }

    private static void testOne() {
        // SimpleDotCom dot = new SimpleDotCom();
        // int[] loc = {2,3,4};
        // dot.setLocationCells(loc);
        // String guess = "2";
        // String result = dot.checkYourself(guess);
        // String testResult = "Fail";

        // if (result.equals("Hit")) {
        //     testResult = "Pass";
        // }
        // System.out.println(testResult);
    }

    private static void testTwo() {
        // SimpleDotCom dot = new SimpleDotCom();
        // int[] loc = {2,3,4};
        // dot.setLocationCells(loc);
        // String result = dot.checkYourself("2");
        // result = dot.checkYourself("3");
        // result = dot.checkYourself("4");
        // String testResult = "Fail";

        // if (result.equals("Ruined")) {
        //     testResult = "Pass";
        // }
        // System.out.println(testResult);
    }
    // Test
    public static void main(String[] args) {
        // testOne();
        // testTwo();
    }
}
