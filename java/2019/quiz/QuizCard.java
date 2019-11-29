public class QuizCard {
    public String question;
    public String answer;

    QuizCard(String q, String a) {
        question = q;
        answer = a;
    }

    public String toString() {
        return "(" + question + "/" + answer + ")";
    }

    public String getQuestion() {
        return question;
    }

    public String getAnswer() {
        return answer;
    }
}
