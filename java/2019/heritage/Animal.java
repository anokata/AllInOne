class Animal {
    int picture;
    String food;
    int hunger;
    long boundaries;
    Location location;

    public void makeNoise() {
    }

    public void eat() {
    }

    public void sleep() {
    }

    public void roam() {
        System.out.println("Roam!");
    }

    private void descriptSelf() {
        System.out.println("Animal: " + hunger);
    }

    public static void main(String[] args) {
        Animal a = new Animal();
        a.descriptSelf();
        Canine c = new Canine();
        c.descriptSelf();
    }
}

class Feline extends Animal {
}

class Canine extends Animal {
    public void roam() {
        super.roam();
        System.out.println("Extended roam");
        System.out.println("Wouf!");
    }

    public void descriptSelf() {
        System.out.println("Canine: " + hunger);
    }
}

class Location {
    public int x;
    public int y;
}

