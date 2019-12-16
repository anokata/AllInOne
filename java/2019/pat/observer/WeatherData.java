import java.util.*;
import java.io.*;
import java.net.*;

class WeatherData {
    public static void main(String[] args) {
        WeatherData app = new WeatherData();
    }

    public int getTemerature() {
        return 0;
    }

    public int getHumidity() {
        return 0;
    }

    public int getPressure() {
        return 0;
    }

    WeatherData () {
        GetWeather getter = new GetWeather();
        System.out.println("Created WeatherData");
    }
}

