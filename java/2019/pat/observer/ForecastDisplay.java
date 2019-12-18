import java.util.Observable;
import java.util.Observer;

class ForecastDisplay implements Observer {
    public static void main(String[] args) {
        System.out.println("Created ForecastDisplay");
    }

    public ForecastDisplay(Observable observable) {
        observable.addObserver(this);
    }

    public void display() {}

    private float currentPressure = 29.92f;
    private float lastPressure;

    public void update(Observable observable, Object arg) {
        if (observable instanceof WeatherData) {
            WeatherData weatherData = (WeatherData) observable;
            lastPressure = currentPressure;
            currentPressure = weatherData.getPressure();
        }
    }

}

