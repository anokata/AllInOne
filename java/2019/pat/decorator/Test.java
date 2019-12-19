public class Test {
    public static void main(String[] args) {
        Beverage beverage = new Espresso();
        System.out.println(beverage.getDescription() + " $" + beverage.cost());

        beverage = new DarkRoast();
        beverage = new Whip(new Mocha(new Mocha(beverage)));
        System.out.println(beverage.getDescription() + " $" + beverage.cost());

        beverage = new HouseBlend();
        beverage = new Soy(beverage);
        beverage = new Mocha(beverage);
        beverage = new Whip(beverage);
        System.out.println(beverage.getDescription() + " $" + beverage.cost());

        beverage = new HouseBlend();
        beverage = new Whip(beverage);
        beverage = new Whip(beverage);
        beverage = new Whip(beverage);
        beverage = new Whip(beverage);
        beverage = new Whip(beverage);
        beverage = new Whip(beverage);
        beverage = new Whip(beverage);
        System.out.println(beverage.getDescription() + " $" + beverage.cost());
    }
}
