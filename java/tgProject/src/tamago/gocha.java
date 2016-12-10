package tamago;

enum Location {
    HOME, WORK, WILD
}

class Inventory {

}

public class gocha {
	private int money = 0;

	private String name = "default Name";
	private int health = 200;
	public int MAX_HEALTH = 200; // calc
	private long age = 0;

	private int fullness = 3;
	public int MIN_FULLNESS = 0;
	public int MAX_FULLNESS = 20;

	private int joy = 0;
	public int MAX_JOY = 20;
	public int MIN_JOY = -20;

	private final int ILLNESS = 2;
	private final int TIMEIDLE_TOSAD = 5;
	private final int TIME_TOHANGER = 4;

	private int availableFood = 3;
	private int idle = 0;
	private boolean debug = false;
	private String stage = "Начало жизни";
	private boolean alive = true;
	private String mood = "avg";
	
	//rpg
	int strength = 1;
	int constitution = 1;
	int agility = 1;
	int intelligence  = 1;
	int luck = 1;
	int willpower = 1;
	long exp = 0;
	int level = 0;
	int statusPoints = 0;
	
	Location location = Location.HOME;
	Inventory inv;

  
	public long getAge() {
		return this.age;
	}
	public String getAgeF() {
		return 
		Long.valueOf(this.age / 1440).toString() + " days " +
		Long.valueOf(this.age / 60).toString() + " hours " +
		Long.valueOf(this.age % 60).toString() + " minutes.";
	}
	public int getHealth() {
		return this.health;
	}
	public String getState() {
		return this.stage;
	}
	public int getJoy() {
		return this.joy;
	}
	public int getfullness() {
		return this.fullness;
	}
	public int getavailableFood() {
		return this.availableFood;
	}
	public void play() {
		incJoy(1);
	}


	private void incHealth(int n) {
		if (health < MAX_HEALTH)
		  health += n;
		if (health > MAX_HEALTH)
		  health = MAX_HEALTH;
	}
	private void decHealth(int n) {
		if (health > 0)
		  health -= n;
	}
	private void decJoy(int n) {
		if (joy - n > MIN_JOY)
		  joy -= n;
	}
	private void incJoy(int n) {
		if (joy + n < MAX_JOY) 
			joy += n;
	}

	public String debugInfo() {
		return name + " Health:" + health + " Age:" + age + " " + stage
		+ " Joy:" + joy + " fullness:" + fullness
		 + ". \n" ;
	}

	public void lifeStep() {
		if (alive) {

		  age++;
		  idle++;
		  if (fullness < MAX_FULLNESS && availableFood > 0)
			eat();
		  if (age % ILLNESS == 0 && fullness < 1)
			decHealth(1);
		  if (age % TIMEIDLE_TOSAD == 0)//(idle >= TIMEIDLE_TOSAD)
			decJoy(1);
		  if (age % TIME_TOHANGER == 0 & fullness > 0)
			fullness--;
			
		 if (joy > MAX_JOY / 2) {
			stage = "Рад";
		  } else if (joy > 0) {
			stage = "Обыденность";
		  } else if (joy < MIN_JOY / 2) {
			stage = "Умирает от скуки";
			decHealth(1);
		  } else if (joy <= 0) {
			stage = "Скучно.";
		  } ;// else stage = "alive.";
		  
		if (health <= 0) {
			stage = "Труп.";
			alive = false;
			if (debug) System.out.println("It goes on... death.");
		  }
		  
		  
			
		if (debug) System.out.print(debugInfo());
		}
	}

	public void food(int n) {
		availableFood += n;
		incJoy(1);
	}

	public void eat() {
		if (debug) System.out.println("Eat");
		//idle = 0;
		if (availableFood > 0) {
		  availableFood--;
		  fullness += 2;
		  incHealth(1);
		}
	}
		
		
	}