import java.util.*;
import java.lang.reflect.*;

class MatchMakingTestDrive {
    public static void main(String[] args) {
        new MatchMakingTestDrive().go();
    }

    HashMap<String, PersonBean> datingDB = new HashMap<String, PersonBean>();

    void go() {
        PersonBean joe = getPersonFromDatabase("Joe Javabean");
        PersonBean ownerProxy = getOwnerProxy(joe);
        System.out.println("name is " + ownerProxy.getName());
        ownerProxy.setInterests("bowling, Go");
        System.out.println("Interests set form owner proxy");
        try {
            ownerProxy.setHotOrNotRating(10);
        } catch (Exception e) {
            System.out.println("Can't set rating for himself");
        }
        System.out.println("Rating is " +ownerProxy.getHotOrNotRating());

        PersonBean nonOwnerProxy = getNotOwnerProxy(joe);
        System.out.println("Name is " + nonOwnerProxy.getName());
        try {
            nonOwnerProxy.setInterests("Some");
        } catch (Exception e) {
            System.out.println("Can't set interests for others");
        }
        nonOwnerProxy.setHotOrNotRating(3);
        System.out.println("Rating is " +ownerProxy.getHotOrNotRating());
    }

	PersonBean getPersonFromDatabase(String name) {
		return (PersonBean)datingDB.get(name);
	}

    public MatchMakingTestDrive() {
        initDB();
    }

    void initDB() {
		PersonBean joe = new PersonBeanImpl();
		joe.setName("Joe Javabean");
		joe.setInterests("cars, computers, music");
		joe.setHotOrNotRating(7);
		datingDB.put(joe.getName(), joe);

		PersonBean kelly = new PersonBeanImpl();
		kelly.setName("Kelly Klosure");
		kelly.setInterests("ebay, movies, music");
		kelly.setHotOrNotRating(6);
		datingDB.put(kelly.getName(), kelly);
    }

    PersonBean getOwnerProxy(PersonBean person) {
        return (PersonBean) Proxy.newProxyInstance(
                person.getClass().getClassLoader(),
                person.getClass().getInterfaces(),
                new OwnerInvocationHandler(person));

    }

    PersonBean getNotOwnerProxy(PersonBean person) {
        return (PersonBean) Proxy.newProxyInstance(
                person.getClass().getClassLoader(),
                person.getClass().getInterfaces(),
                new NotOwnerInvocationHandler(person));

    }

    PersonBean getPersonProxy(PersonBean person, InvocationHandler handler) {
        return (PersonBean) Proxy.newProxyInstance(
                person.getClass().getClassLoader(),
                person.getClass().getInterfaces(), handler);
    }
}
