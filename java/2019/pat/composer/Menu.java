import java.util.*;
import java.util.Iterator;

public class Menu extends MenuComponent {
    ArrayList<MenuComponent> menuComponents = new ArrayList<MenuComponent>();
    String name;
    String desc;
    Iterator<MenuComponent> iterator = null;

    public Menu(String name, String desc) {
        this.name = name;
        this.desc = desc;
    }

    public Iterator<MenuComponent> createIterator() {
        if (iterator == null) {
            iterator = new CompositeIterator(menuComponents.iterator());
        }
        return iterator;
    }

    public void add(MenuComponent menuComponent) {
        menuComponents.add(menuComponent);
    }

    public void remove(MenuComponent c) {
        menuComponents.remove(c);
    }

    public MenuComponent getChild(int i) {
        return menuComponents.get(i);
    }

    public String getName() { return name; }
    public String getDescription() { return desc; }

    public void print() {
        System.out.println(getName() + ", " + getDescription());
        System.out.println("-----------------");
        Iterator<MenuComponent> i = menuComponents.iterator();
        while (i.hasNext()) {
            MenuComponent menuComponent = i.next();
            menuComponent.print();
        }
    }
}
