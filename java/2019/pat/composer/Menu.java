import java.util.*;
import java.util.Iterator;

public class Menu extends MenuComponent {
    ArrayList<MenuComponent> menuComponents = new ArrayList<MenuComponent>();
    String name;
    String desc;

    public Menu(String name, String desc) {
        this.name = name;
        this.desc = desc;
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
