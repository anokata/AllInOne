class SimpleRemoteControl {
    Command slot;

    public static void main(String[] args) {
        SimpleRemoteControl r = new SimpleRemoteControl();
        r.setCommand(new LightCommand(new Light()));
        r.button1Pressed();

        r.setCommand(new GarageDoorOpenCommand(new GarageDoor()));
        r.button1Pressed();
    }

    public void setCommand(Command cmd) {
        slot = cmd;
    }

    public void button1Pressed() {
        slot.execute();
    }

    SimpleRemoteControl () {
        System.out.println("Created SimpleRemoteControl");
    }
}

