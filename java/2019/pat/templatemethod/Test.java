class Test {
    public static void main(String[] args) {
        Beverage cup1 = new Coffe();
        Beverage cup2 = new Tea();
        Beverage cup3 = new BlankTea();

        cup1.prepareRecipe();
        cup2.prepareRecipe();
        System.out.println();
        cup3.prepareRecipe();
    }
}

