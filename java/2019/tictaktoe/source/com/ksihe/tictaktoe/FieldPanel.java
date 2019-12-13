package com.ksihe.tictaktoe;
import java.awt.event.*;
import javax.swing.*;
import java.awt.*;

class FieldPanel extends JPanel {

    // отделить метод отображения поля от панели
    FieldDrawer painter;

    public void paintComponent(Graphics g) {
            super.paintComponent(g);
            painter.paint(g, this);
    };

    FieldPanel(Painter p) {
        painter = p;
    }
    public static void main(String[] args) {}
}
