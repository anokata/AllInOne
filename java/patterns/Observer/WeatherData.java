import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

public class WeatherData implements Subject {
    private static final int CHANGE_GAP = 2*1000;

    private Timer timer;
    private float temperature = 0.0f;
    private float humidity = 0.0f;
    private float pressure = 0.0f;
    private ArrayList<Observer> observers;

    public WeatherData() {
        timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
          @Override
          public void run() {
              tick();
          }
        }, CHANGE_GAP, CHANGE_GAP);

        observers = new ArrayList<Observer>();
    }

    public void registerObserver(Observer o) {
        observers.add(o);
    }

    public void removeObserver(Observer o) {
        int i = observers.indexOf(o);
        if (i >= 0) {
            observers.remove(i);
        }
    }

    public void notifyObservers() {
        observers.forEach(o -> o.update(temperature, humidity, pressure));
    }

    public float getTemperature() { 
        return temperature;
    }

    public float getHumidity() { 
        return humidity;
    }

    public float getPressure() { 
        return pressure;
    }

    public void mesurementChanged() {
        notifyObservers();
    }

    private void tick() {
        temperature++;
        mesurementChanged();
    }

    public static void main(String[] args) {
        WeatherData wd = new WeatherData();
        Observer ccd = new CurrentConditionsDisplay(wd);
        System.out.println("started.");
        wd.setMeasurments();
    }

    public void setMeasurments() {
        humidity = (float) Math.random();
    }
}

interface Observer {
    void update(float temp, float humidity, float pressure);
}

interface Subject {
    void registerObserver(Observer o);
    void removeObserver(Observer o);
    void notifyObservers();
}

interface DisplayElement {
    void display();
}

class CurrentConditionsDisplay implements Observer, DisplayElement {
    private float temperature;
    private float humidity;
    private Subject weatherData;

    public CurrentConditionsDisplay(Subject weatherData) {
        this.weatherData = weatherData;
        weatherData.registerObserver(this);
    }
    
    public void update(float temp, float humidity, float pressure) {
        temperature = temp;
        this.humidity = humidity;
        display();
    }

    public void display() {
        System.out.println("changed>" 
                + " temp: " + temperature
                + " humi: " + humidity);
    }

}

