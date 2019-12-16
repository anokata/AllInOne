import java.awt.event.*;
import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.io.*;
import java.net.*;

class CurrentDisplay implements Display {
    JFrame frame = new JFrame();


    public static void main(String[] args) {
        CurrentDisplay app = new CurrentDisplay();
    }

    CurrentDisplay () {
        System.out.println("Created CurrentDisplay");
    }

    public void update(int temperature, int humidity, int pressure) {
    }
}

