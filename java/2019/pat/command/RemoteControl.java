class RemoteControl {
    Command[] onCmd;
    Command[] offCmd;
    Command undoCmd;

    public static void main(String[] args) {
        RemoteControl r = new RemoteControl();
        System.out.println(r);

        Light l = new Light("Living room");
        Light k = new Light("Kitchen");
        GarageDoor g = new GarageDoor();
        Stereo s = new Stereo();

        LightCommand lon = new LightCommand(l);
        LightOffCommand lof = new LightOffCommand(l);
        LightCommand kon = new LightCommand(k);
        LightOffCommand kof = new LightOffCommand(k);

        GarageDoorOpenCommand gon = new GarageDoorOpenCommand(g);
        StereoOffCommand sof = new StereoOffCommand(s);
        StereoOnCommand son = new StereoOnCommand(s);

        r.setCommand(0, lon, lof);
        r.setCommand(1, kon, kof);
        r.setCommand(2, son, sof);
        r.setCommand(3, gon, gon);

        System.out.println(r);

        r.onButtonPushed(0);
        r.offButtonPushed(0);

        r.onButtonPushed(1);
        r.offButtonPushed(1);

        r.onButtonPushed(2);
        r.offButtonPushed(2);

        r.undoButton();
        r.undoButton();

        Command[] partyOn = {lon, kon, son, gon};
        Command[] partyOff = {lof, kof, sof};
        MacroCommand partyOnMacro = new MacroCommand(partyOn);
        MacroCommand partyOffMacro = new MacroCommand(partyOff);
        r.setCommand(3, partyOnMacro, partyOffMacro);

        r.onButtonPushed(3);
        r.offButtonPushed(3);

        // on fly garage off
        // need Command with one method(functional interface)
        //r.setCommand(4, () -> { g.close(); }, () -> { g.open();} );
        // or direct link to method
        //r.setCommand(4, g::open, g::close);
    }

    RemoteControl () {
        onCmd = new Command[7];
        offCmd = new Command[7];
        Command noCmd = new NoCommand();

        for (int i=0; i<7; i++) {
            onCmd[i] = noCmd;
            offCmd[i] = noCmd;
        }
        undoCmd = noCmd;
        System.out.println("Created RemoteControl");
    }

    public void setCommand(int slot, Command on, Command off) {
        onCmd[slot] = on;
        offCmd[slot] = off;
    }

    public void onButtonPushed(int slot) {
        onCmd[slot].execute();
        undoCmd = onCmd[slot];
    }

    public void offButtonPushed(int slot) {
        offCmd[slot].execute();
        undoCmd = offCmd[slot];
    }

    public void undoButton() {
        undoCmd.undo();
    }

    public String toString() {
        StringBuffer s = new StringBuffer();
        s.append("\n----- Remote Control -----\n");
        for (int i=0; i<onCmd.length; i++) {
            s.append("[slot " + i + "] " + onCmd[i].getClass().getName() + "   \t" + offCmd[i].getClass().getName() + "\n");
        }
        return s.toString();
    }
}

class NoCommand implements Command {
    public void execute() {}
    public void undo() {}
}
