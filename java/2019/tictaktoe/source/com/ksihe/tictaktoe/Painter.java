package com.ksihe.tictaktoe;
import java.awt.event.*;
import javax.swing.*;
import java.awt.*;

class Painter {
    public static void main(String[] args) {}

    GameField field;

    public void paint(Graphics g, JComponent self) {
        g.setColor(Color.GRAY);
        g.fillRect(0,0, self.getHeight(), self.getWidth());
    }

    Painter(GameField f) {
        field = f;
    }
}

