package ai.eu.work.forecast;

import java.util.*;
import ai.eu.work.forecast.ForecastObtainer;

public class NowcastFormat {
    private static float currentTemperature;
    private static float currentPressure;
    private static float currentWindSpeed;

    private static void refreshData()
            throws Exception {
        ArrayList<HashMap<String, String>> cast = 
            (ArrayList<HashMap<String, String>>) ForecastObtainer.getYRNOForecast();
        currentTemperature = Float.parseFloat(cast.get(0).get("temperature"));
        currentPressure = Float.parseFloat(cast.get(0).get("pressure"));
        currentWindSpeed = Float.parseFloat(cast.get(0).get("windSpeed"));
    }

    public static void main(String[] args) 
            throws Exception {
        refreshData();
        System.out.println(currentTemperature);
        System.out.println(currentPressure);
        System.out.println(currentWindSpeed);
    }
}
