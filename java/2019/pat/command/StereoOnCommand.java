class StereoOnCommand implements Command {
    Stereo stereo;

    StereoOnCommand(Stereo s) {
        stereo = s;
    }

    public void execute() {
        stereo.on();
        stereo.setCd();
        stereo.setVolume(11);
    }
}
