class LightCommand implements Command {
    Light light;

    public LightCommand(Light light) {
        this.light = light;
    }

    public void execute() {
        System.out.println("cmd:Light is on");
        light.on();
    }
}
