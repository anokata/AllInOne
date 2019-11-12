class SimpleDotComGame {
    /*
     * создать SimpleDotCom
     * выбрать случайную позицию и настроить созданный объект
     * Пока не потоплено:
     * Предлагаем сделать ход
     * получаем ввод пользователя
     * проверяем введённый ход
     * даём объекту на проверку
     * если попал то numOfGuesses++
     * если потоплен то конец игры - вывод количества попыток
     */

    public static void main(String[] args) { 
        int numOfGuesses = 0;
        GameHelper helper = new GameHelper();

        SimpleDotCom theDotCom = new SimpleDotCom();
        int randomNum = (int) (Math.random() * 5);
        //int[] locations = {randomNum, randomNum+1, randomNum+2};
        theDotCom.setLocationCells(locations);
        boolean isAlive = true;

        while (isAlive) {
            String guess = helper.getUserInput("Enter move:");
            String result = theDotCom.checkYourself(guess);
            numOfGuesses++;
            if (result.equals("Ruined")) {
                isAlive = false;
                System.out.println("You tried " + numOfGuesses + " tries.");
            }
        }
    }
}
