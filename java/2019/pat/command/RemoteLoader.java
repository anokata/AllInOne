class RemoteLoader {
    public static void main(String[] args) {
        RemoteControl r = new RemoteControl();
        CeilingFan f = new CeilingFan("Room");
        CeilingFanHighCommand ch = new CeilingFanHighCommand(f);
        CeilingFanLowCommand cl = new CeilingFanLowCommand(f);

        r.setCommand(0, ch, cl);
        r.onButtonPushed(0);
        r.offButtonPushed(0);
        //System.out.println(r);
        System.out.println("");
        r.undoButton();

        r.offButtonPushed(0);
        System.out.println("");
        r.undoButton();
        System.out.println("");
    }
}

