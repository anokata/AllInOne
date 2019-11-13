import java.util.*;

class DotComGame {
    private GameHelper helper = new GameHelper();
    private ArrayList<DotCom> dotComsList = new ArrayList<DotCom>();
    private int numOfGuesses = 0;

    public void setUpGame() {
        for (int i = 0; i < 3; i++) {
            DotCom d = new DotCom();
            dotComsList.add(d);
            ArrayList<String> locations = helper.placeDotCom(3);
            d.setLocationCells(locations);
        }
        dotComsList.get(0).setName("Hello.com");
        dotComsList.get(1).setName("noname.com");
        dotComsList.get(2).setName("china.com");
        System.out.println("Trie ruine 3 sites, enter move like E2... A-G 1-7");
    }

    public void startPlaying() {
        while (!dotComsList.isEmpty()) {
            String guess = helper.getUserInput("Enter move:");
            checkUserGuess(guess);
        }
        finishGame();
    }

    public void checkUserGuess(String guess) {
        numOfGuesses++;
        String result = "Miss";
        for (DotCom d : dotComsList) {
            result = d.checkYourself(guess);
            if (result.equals("Hit")) {
                break;
            }
            if (result.equals("Ruined")) {
                dotComsList.remove(d);
                break;
            }
        }
        System.out.println(result);
    }

    public void finishGame() {
        System.out.println("Win! You tried " + numOfGuesses + " tries.");
        if (numOfGuesses <= 18) {
            System.out.println("Impressive!");
        } else {
            System.out.println("Not bad.");
        }
    }

    public static void main(String[] args) { 
        DotComGame game = new DotComGame();
        game.setUpGame();
        game.startPlaying();
    }
}
