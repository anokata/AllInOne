class HomeFacade {
    Tuner tuner;
    Lights lights;
    DvdPlayer dvd;

    public static void main(String[] args) {
        HomeFacade app = new HomeFacade(
                new Tuner(),
                new Lights(),
                new DvdPlayer()
                );
        app.watchMovie("Home Alone");
        app.endMovie();
    }

    HomeFacade (
            Tuner tuner,
            Lights lights,
            DvdPlayer dvd
            ) {
        this.tuner = tuner;
        this.dvd = dvd;
        this.lights = lights;
        System.out.println("Created HomeFacade");
    }

    public void watchMovie(String movie) {
        System.out.println("Get ready to watch a movie...");
        lights.dim(10);
        tuner.on();
        dvd.on();
        dvd.play(movie);
    }

    public void endMovie() {
        System.out.println("");
        lights.on();
        tuner.off();
        dvd.stop();
        dvd.off();
    }

}

