package com.ksihe.tictaktoe;
import java.awt.event.*;
import javax.swing.*;
import java.awt.*;

class FieldPanel extends JPanel {

    // отделить метор отображения поля от панели

    public void paintComponent(Graphics g) {
            super.paintComponent(g);
            g.setColor(Color.GRAY);
            g.fillRect(0,0, getHeight(), getWidth());
            // call this.painter.paintme(this, g);
            // painter is game view logic with field
    };
    public static void main(String[] args) {}
}
