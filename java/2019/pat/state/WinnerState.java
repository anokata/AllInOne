class WinnerState implements State {
    public static void main(String[] args) {
        WinnerState app = new WinnerState();
    }

    WinnerState () {
        System.out.println("Created WinnerState");
    }

    // "рано сувать"
    public void insertQuarter() {
    }

    // "потрачено"
    public void ejectQuarter() {
    }

    // "уже выдаю"
    public void turnCrank() {
    }

    // "удача!" выдать и >? -> SoldOutState | NoQuarterState
    public void dispense() {
    }
}

