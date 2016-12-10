package tamago;

import tamago.gocha;

public class gochaTest {
  public static void main(String args[]) {
    gocha g = new gocha();
    System.out.print(g.debugInfo());
    //eat
    for (int i = 0; i < 50; i++) {
        if (i % 10 == 0)
        g.food(3);
      g.lifeStep();
      }
    //death
    for (int i = 0; i < 100; i++) {
      g.lifeStep();
      }
    
  }
}