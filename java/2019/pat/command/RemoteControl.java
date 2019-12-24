class RemoteControl {
    Command[] onCmd;
    Command[] offCmd;

    public static void main(String[] args) {
        RemoteControl app = new RemoteControl();
        System.out.println(app);
    }

    RemoteControl () {
        onCmd = new Command[7];
        offCmd = new Command[7];
        Command noCmd = new NoCommand();

        for (int i=0; i<7; i++) {
            onCmd[i] = noCmd;
            offCmd[i] = noCmd;
        }
        System.out.println("Created RemoteControl");
    }

    public void setCommand(int slot, Command on, Command off) {
        onCmd[slot] = on;
        offCmd[slot] = off;
    }

    public void onButtonPushed(int slot) {
        onCmd[slot].execute();
    }

    public void offButtonPushed(int slot) {
        offCmd[slot].execute();
    }

    public String toString() {
        StringBuffer s = new StringBuffer();
        s.append("\n----- Remote Control -----\n");
        for (int i=0; i<onCmd.length; i++) {
            s.append("[slot " + i + "] " + onCmd[i].getClass().getName() + "  " + offCmd[i].getClass().getName() + "\n");
        }
        return s.toString();
    }
}

class NoCommand implements Command {
    public void execute() {}
}
