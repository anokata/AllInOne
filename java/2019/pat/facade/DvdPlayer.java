class DvdPlayer {
    public static void main(String[] args) {
        DvdPlayer app = new DvdPlayer();
    }

    DvdPlayer () {
        System.out.println("Created DvdPlayer");
    }

    public void on() {
        System.out.println("dvd on");
    }
    public void off() {
        System.out.println("dvd off");
    }
    public void stop() {
        System.out.println("dvd Stoped");
    }
    public void play(String movie) {
        System.out.println("Playing " + movie);
    }
}

