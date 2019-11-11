class SimpleDotCom {
    private int[] locationCells;
    private int numOfHits;

    public String checkYourself(String strGuess) {
        int guess = Integer.parseInt(strGuess);
        String result = "Miss";
        for (int cell : locationCells) {
            if (guess == cell) {
                result = "Hit";
                numOfHits++;
                break;
            }
        }

        if (numOfHits == locationCells.length) {
            result = "Ruined";
        }

        System.out.println(result);
        return result;
    }

    public void setLocationCells(int[] loc){
        locationCells = loc;
    }

    private static void testOne() {
        SimpleDotCom dot = new SimpleDotCom();
        int[] loc = {2,3,4};
        dot.setLocationCells(loc);
        String guess = "2";
        String result = dot.checkYourself(guess);
        String testResult = "Fail";

        if (result.equals("Hit")) {
            testResult = "Pass";
        }
        System.out.println(testResult);
    }

    private static void testTwo() {
        SimpleDotCom dot = new SimpleDotCom();
        int[] loc = {2,3,4};
        dot.setLocationCells(loc);
        String result = dot.checkYourself("2");
        result = dot.checkYourself("3");
        result = dot.checkYourself("4");
        String testResult = "Fail";

        if (result.equals("Ruined")) {
            testResult = "Pass";
        }
        System.out.println(testResult);
    }
    // Test
    public static void main(String[] args) {
        testOne();
        testTwo();
    }
}
