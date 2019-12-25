class CeilingFanLowCommand implements Command {
    CeilingFan ceilingFan;
    int prevSpeed;

    public static void main(String[] args) {
        CeilingFanLowCommand app = new CeilingFanLowCommand(new CeilingFan("room"));
    }

    CeilingFanLowCommand (CeilingFan fan) {
        this.ceilingFan = fan;
    }

    public void execute() {
        prevSpeed = ceilingFan.getSpeed();
        ceilingFan.low();
    }

    public void undo() {
        switch (prevSpeed) {
            case (CeilingFan.HIGH): {
                ceilingFan.high(); break; }
            case (CeilingFan.LOW): {
                ceilingFan.low();  break;}
            case (CeilingFan.MEDIUM): {
                ceilingFan.medium(); break; }
            case (CeilingFan.OFF): {
                ceilingFan.off(); break; }
        }
    }
}

