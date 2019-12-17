class Main {
    public static void main(String[] args) {
        Main app = new Main();
    }

    Main () {
        WeatherData wd = new WeatherData();
        CurrentDisplay d = new CurrentDisplay(wd);
        wd.notifyDisplays();
    }
}

