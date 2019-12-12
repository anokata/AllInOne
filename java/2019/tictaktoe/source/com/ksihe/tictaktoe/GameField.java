package com.ksihe.tictaktoe;
import static java.lang.System.out;

class GameField {
    Cell[][] cells;

    GameField(int dim) {
        cells = new Cell[3][3];
        for (int x = 0; x < dim; x++) {
            for (int y = 0; y < dim; y++) {
                cells[x][y] = Cell.FREE;
            }
        }
    }

    void logprint() {
        for (Cell[] x : cells) {
            for (Cell c : x) {
                out.print(c + " ");
            }
            out.println(" ");
        }
    }

    public static void main(String[] args) {
        System.out.println("Test GameField");
        new GameField(3).test();
    }

    void test() {
        logprint();
    }
}


enum Cell {
    FREE,
    CROSS,
    CIRCLE
}
