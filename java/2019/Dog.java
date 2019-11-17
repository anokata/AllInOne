class Dog {
    private int size;
    private String breed;
    private String name;

    public Dog(String name) {
        this.name = name;
    }

    // overlap Object.toString
    public String toString() {
        return super.toString() + "  I'm " + name + " dog";
    }

    public void bark() {
        System.out.println("Gaw! I'm " + name);
    }
    
    public void setSize(int s) {
        size = s;
    }

    public void setBreed(String b) {
        breed = b;
    }

    public void setName(String n) {
        name = n;
    }

    public String getName() {
        return name;
    }
}
