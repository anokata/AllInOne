public class PhraseBuilder {
    public static void main(String[] args) {
        String[] wordlist1 = {"one", "some"};
        String[] wordlist2 = {"two", "any"};
        String[] wordlist3 = {"three", "nothing"};
        int rand1 = (int) (Math.random() * wordlist1.length);
        int rand2 = (int) (Math.random() * wordlist2.length);
        int rand3 = (int) (Math.random() * wordlist3.length);
        String phrase = wordlist1[rand1] + " " + 
            wordlist2[rand2] + " " +
            wordlist3[rand3] + ".";
        System.out.println(phrase);
    }
}

class PBuilder {
    //public abstract PBuilder();
    private String[] _wordlist;
}
