import java.util.*;
import java.io.*;
import java.net.*;

class WeatherData {

    ArrayList<Display> displays;

    public static void main(String[] args) {
        WeatherData app = new WeatherData();
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
        GetWeather getter = new GetWeather();
        System.out.println("Created WeatherData");
        // every second change
    }

    public void changed() {
        for (Display d : displays) {
            d.update(getTemerature(), getHumidity(), getPressure());
        }
    }
}

