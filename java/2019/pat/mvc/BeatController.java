class BeatController implements ControllerInterface {
    public static void main(String[] args) {
        BeatController app = new BeatController(new BeatModel());
    }

    BeatModelInterface model;
    DJView view;

    BeatController (BeatModelInterface model) {
        this.model = model;
        view = new DJView(this, model);
        view.createView();
        view.createControls();
        view.disableStopMenuItem();
        view.enableStartMenuItem();
        model.initialize();
    }
    
    public void start() {
        model.on();
        view.disableStartMenuItem();
        view.enableStopMenuItem();
    }

    public void stop() {
        model.off();
        view.disableStopMenuItem();
        view.enableStartMenuItem();
    }

    public void increaseBPM() {
        int bpm = model.getBPM();
        model.setBPM(bpm + 1);
        System.out.println("Set bpm to " + model.getBPM());
    }

    public void decreaseBPM() {
        int bpm = model.getBPM();
        model.setBPM(bpm - 1);
        System.out.println("Set bpm to " + model.getBPM());
    }

    public void setBPM(int bpm) {
        model.setBPM(bpm);
    }
}

