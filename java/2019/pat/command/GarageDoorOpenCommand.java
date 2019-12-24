class GarageDoorOpenCommand implements Command {
    GarageDoor door;

    GarageDoorOpenCommand(GarageDoor d) {
        door = d;
    }

    public void execute() {
        door.open();
    }

    public void undo() {
    }
}
