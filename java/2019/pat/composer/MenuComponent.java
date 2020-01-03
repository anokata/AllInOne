import java.util.Iterator;

abstract class MenuComponent {
    public String getName() {
        throw new UnsupportedOperationException();
    }
    public String getDescription() {
        throw new UnsupportedOperationException();
    }
    public double getPrice() {
        throw new UnsupportedOperationException();
    }
    public boolean isVegetarian() {
        throw new UnsupportedOperationException();
    }

    public void print(){
        throw new UnsupportedOperationException();
    }

    public void add(MenuComponent c) {
        throw new UnsupportedOperationException();
    }
    public void remove(MenuComponent c) {
        throw new UnsupportedOperationException();
    }
    public MenuComponent getChild(int i) {
        throw new UnsupportedOperationException();
    }

    public abstract Iterator<MenuComponent> createIterator();


    public static void main(String[] args) { }

    MenuComponent () {
        System.out.println("Created MenuComponent");
    }
}

