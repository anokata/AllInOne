import java.awt.event.*;
import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.io.*;
import java.net.*;

class CurrentDisplay implements WeatherDataObserver {
    JFrame frame = new JFrame();
    WeatherDataSubject weatherSubject;

    public static void main(String[] args) {
        WeatherData d = new WeatherData();
        CurrentDisplay app = new CurrentDisplay(d); // test only
        d.notifyDisplays();
    }

    CurrentDisplay (WeatherDataSubject wds) {
        wds.register(this);
        weatherSubject = wds;
        System.out.println("Created CurrentDisplay");
    }

    public void update(int temperature, int humidity, int pressure) {
        System.out.println("Current: ");
        System.out.println("T:" + temperature);
    }
}

