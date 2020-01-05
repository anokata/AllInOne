class SoldState implements State {
    public static void main(String[] args) {
        SoldState app = new SoldState();
    }

    SoldState () {
        System.out.println("Created SoldState");
    }

    // "подождите выдачи"
    public void insertQuarter() {
    }

    // "нельзя вернуть, потрачено"
    public void ejectQuarter() {
    }

    // "уже выдаётся"
    public void turnCrank() {
    }

    // выдать, >0? перейти NoQuarterState или SoldOutState
    public void dispense() {
    }
}

