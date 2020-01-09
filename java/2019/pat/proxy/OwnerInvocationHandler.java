import java.lang.reflect.*;

class OwnerInvocationHandler implements InvocationHandler {
    PersonBean person;

    public static void main(String[] args) {
        //OwnerInvocationHandler app = new OwnerInvocationHandler();
    }

    OwnerInvocationHandler (PersonBean person) {
        this.person = person;
        System.out.println("Created OwnerInvocationHandler with " + person);
    }

    public Object invoke(Object proxy, Method method, Object[] args) throws IllegalAccessException {
        try {
            if (method.getName().startsWith("get")) {
                return method.invoke(person, args);
            } else if (method.getName().equals("setHotOrNotRating")) {
                throw new IllegalAccessException();
            } else if (method.getName().startsWith("set")) {
                return method.invoke(person, args);
            }
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        return null;
    }
}

