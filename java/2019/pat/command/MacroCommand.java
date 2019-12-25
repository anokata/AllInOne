class MacroCommand implements Command {

    Command[] commands;

    public static void main(String[] args) {
        Command[] c = {new LightCommand(new Light(""))};
        MacroCommand app = new MacroCommand(c);
    }

    MacroCommand (Command[] commands) {
        System.out.println("Created MacroCommand");
        this.commands = commands;
    }

    public void execute() {
        for(Command cmd : commands) {
            cmd.execute();
        }
    }
    
    public void undo() {
        for(Command cmd : commands) {
            cmd.undo();
        }
    }
}

