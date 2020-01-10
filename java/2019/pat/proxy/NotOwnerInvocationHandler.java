import java.lang.reflect.*;

class NotOwnerInvocationHandler implements InvocationHandler {
    PersonBean person;

    public static void main(String[] args) {
        //OwnerInvocationHandler app = new OwnerInvocationHandler();
    }

    NotOwnerInvocationHandler (PersonBean person) {
        this.person = person;
        System.out.println("Created NotOwnerInvocationHandler with " + person);
    }

    public Object invoke(Object proxy, Method method, Object[] args) throws IllegalAccessException {
        System.out.println("Method: " + method.getName());
        try {
            if (method.getName().startsWith("get")) {
                return method.invoke(person, args);
            } else if (method.getName().equals("setHotOrNotRating")) {
                return method.invoke(person, args);
            } else if (method.getName().startsWith("set")) {
                throw new IllegalAccessException();
            }
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        return null;
    }
}


