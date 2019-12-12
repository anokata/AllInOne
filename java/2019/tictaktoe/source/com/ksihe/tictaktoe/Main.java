package com.ksihe.tictaktoe;
import java.awt.event.*;
import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.io.*;
import java.net.*;

class Main {
    public static void main(String[] args) {
        Main app = new Main();
    }

    Main () {
        System.out.println("Created Main");
        gui();
    }

    JFrame frame = new JFrame();
    GameField gameField = new GameField(3);
    FieldPanel field = new FieldPanel();

    void gui() {
        frame.add(field);
        gameField.logprint();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(800, 600);
        frame.setVisible(true);
    }
}

