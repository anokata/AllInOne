class Animal {
    int picture;
    String food = "it";
    int hunger;
    long boundaries;
    Location location;

    public void makeNoise() {
        System.out.println("Bzz");
    }

    public void eat() {
        System.out.println("Eat " + food);
    }

    public void sleep() {
        System.out.println("SleepZzz..");
    }

    public void roam() {
        System.out.println("Roam!");
    }

    // Если объявить private то не унаследуется
    // и если переопределить то вызванный методы будет зависеть от типа ссылки
    public void descriptSelf() {
        System.out.println("Animal: " + hunger);
    }

    // Перегруженые методы - ничего общего с полиморфизмом
    int overloadable(int x) {
        return x + 1;
    }
    double overloadable(double x) {
        return x + 1;
    }
    int overloadable(Animal a) {
        return a.hunger + 1;
    }

    public static void main(String[] args) {
        Animal a = new Animal();
        a.descriptSelf();
        Canine c = new Canine();
        c.descriptSelf();
        Animal[] animals = new Animal[5];
        animals[0] = new Canine(); // Полиморфно, сслыка типа Animal ссылается на дочерний Canine
        animals[1] = new Feline();
        animals[2] = new Animal();

        for (Animal i : animals) {
            if (i != null) {
                i.descriptSelf();
                i.eat();
                i.roam();
            }
        }
    }
}

class Feline extends Animal {
    public void roam() {
        System.out.println("Meow!");
    }

    public void descriptSelf() {
        System.out.println("Feline: " + hunger);
    }
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

