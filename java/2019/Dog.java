class Dog {
    int size;
    String breed;
    String name;

    public Dog(String name) {
        this.name = name;
    }

    void bark() {
        System.out.println("Gaw! I'm " + name);
    }
}
