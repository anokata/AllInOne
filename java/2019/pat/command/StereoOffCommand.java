class StereoOffCommand implements Command {
    Stereo stereo;

    StereoOffCommand(Stereo s) {
        stereo = s;
    }

    public void execute() {
        stereo.off();
    }
    public void undo() {
        stereo.on();
    }
}
