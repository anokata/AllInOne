import java.util.*;
import java.util.Iterator;

class CompositeIterator implements Iterator {
    Stack<Iterator<MenuComponent>> stack = new Stack<Iterator<MenuComponent>>();

    public static void main(String[] args) {
        MenuComponent diner = new Menu("Dinner", "");
        CompositeIterator app = new CompositeIterator(diner.createIterator());
    }

    CompositeIterator (Iterator iterator) {
        stack.push(iterator);
        System.out.println("Created CompositeIterator");
    }

    public Object next() {
        if (hasNext()) { 
            Iterator<MenuComponent> iterator = stack.peek();
            MenuComponent component = iterator.next();
            stack.push(component.createIterator());
            return component;
        } else {
            return null;
        }
    }

    public boolean hasNext() {
        if (stack.isEmpty()) {
            return false;
        } else {
            Iterator<MenuComponent> iterator = stack.peek();
            if (!iterator.hasNext()) {
                stack.pop();
                return hasNext();
            } else { 
                return true;
            }
        }
    }
}

