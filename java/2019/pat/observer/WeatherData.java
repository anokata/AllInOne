import java.util.*;
import java.io.*;
import java.net.*;

class WeatherData implements WeatherDataSubject {

    ArrayList<WeatherDataObserver> displays = new ArrayList<WeatherDataObserver>();

    public static void main(String[] args) {
        WeatherData app = new WeatherData();
    }

    public void register(WeatherDataObserver w) {
        displays.add(w);
    }

    public void remove(WeatherDataObserver w) {
        if (displays.indexOf(w) >=0 ) {
            displays.remove(w);
        }
    }

    public void notifyDisplays() {
        for (WeatherDataObserver d : displays) {
            d.update(getTemerature(), getHumidity(), getPressure());
        }
    }

    public int getTemerature() {
        return (int) (Math.random() * 100);
    }

    public int getHumidity() {
        return (int) (Math.random() * 100);
    }

    public int getPressure() {
        return (int) (Math.random() * 100);
    }

    WeatherData () {
        //GetWeather getter = new GetWeather();
        System.out.println("Created WeatherData");
        // every second change
    }

}

