public class Test {
    public static void main(String[] args) {
        Beverage beverage = new Espresso();
        System.out.println(beverage.getDescription() + " $" + beverage.cost());

        beverage = new DarkRoast();
        beverage = new Whip(new Mocha(new Mocha(beverage)));
        System.out.println(beverage.getDescription() + " $" + beverage.cost());

        beverage = new HouseBlend();
        //
        System.out.println(beverage.getDescription() + " $" + beverage.cost());
    }
}
