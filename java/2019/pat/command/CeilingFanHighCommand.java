class CeilingFanHighCommand implements Command {
    CeilingFan ceilingFan;
    int prevSpeed;

    public static void main(String[] args) {
        CeilingFanHighCommand app = new CeilingFanHighCommand(new CeilingFan("room"));
    }

    CeilingFanHighCommand (CeilingFan fan) {
        this.ceilingFan = fan;
    }

    public void execute() {
        prevSpeed = ceilingFan.getSpeed();
        ceilingFan.high();
    }

    public void undo() {
        switch (prevSpeed) {
            case (CeilingFan.HIGH): {
                ceilingFan.high(); break; }
            case (CeilingFan.LOW): {
                ceilingFan.low(); break; }
            case (CeilingFan.MEDIUM): {
                ceilingFan.medium(); break; }
            case (CeilingFan.OFF): {
                ceilingFan.off();  break;}
        }
    }
}

