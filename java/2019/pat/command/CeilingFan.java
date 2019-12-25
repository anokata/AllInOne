class CeilingFan {

    public static final int HIGH = 3;
    public static final int MEDIUM = 2;
    public static final int LOW = 1;
    public static final int OFF = 0;
    String location;
    int speed;

    public static void main(String[] args) {
        CeilingFan app = new CeilingFan("there");
    }

    CeilingFan (String location) {
        System.out.println("Created CeilingFan in " + location);
        this.location = location;
    }

    public void stat() { System.out.println("Fan: " + speed);}

    public void high() { speed = HIGH; stat();}
    public void low() { speed = LOW; stat();}
    public void medium() { speed = MEDIUM; stat();}
    public void off() { speed = OFF; stat();}
    public int getSpeed() { return speed; }
}

