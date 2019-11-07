class Game {
    Player p1;
    Player p2;
    Player p3;

    public void start() {
        p1 = new Player();
        p2 = new Player();
        p3 = new Player();
        
        int guessp1 = 0;
        int guessp2 = 0;
        int guessp3 = 0;

        boolean p1isRight = false;
        boolean p2isRight = false;
        boolean p3isRight = false;

        int theNumber = makeTheNumber();
        while (true) {
            p1.guess();
            p2.guess();
            p3.guess();

            guessp1 = p1.number;
            System.out.println("Player 1 think is: " + guessp1);
            guessp2 = p2.number;
            System.out.println("Player 2 think is: " + guessp2);
            guessp3 = p3.number;
            System.out.println("Player 3 think is: " + guessp3);

            if (guessp1 == theNumber) {
                p1isRight = true;
            }
            if (guessp2 == theNumber) {
                p2isRight = true;
            }
            if (guessp3 == theNumber) {
                p3isRight = true;
            }

            if (p1isRight || p2isRight || p3isRight) {
                print("Here winner!");
                if (p1isRight) {
                    print("1st Player win!");
                }
                if (p2isRight) {
                    print("2nd Player win!");
                }
                if (p3isRight) {
                    print("3rd Player win!");
                }
                print("Game Over!");
                break;
            } else {
                print("Take other guess.");
            }

        }
    }

    private int makeTheNumber() {
        System.out.println("I make number between 0 and 9 ...");
        return (int) (Math.random() * 10);
    }

    private void print(String s) {
        System.out.println(s);
    }
}
