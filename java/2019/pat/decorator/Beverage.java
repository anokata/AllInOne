abstract class Beverage {
    public enum Size { TALL, GRANDE, VENTI };
    Size size = Size.TALL;
    String description = "Unknow beverage";
    public String getDescription() { return description; }

    abstract public double cost();

    public static void main(String[] args) {
    }

    Beverage () {
        System.out.println("Created Beverage");
    }

    public void setSize(Size size) {
        this.size = size;
    }

    public Size getSize() {
        return size;
    }
}

