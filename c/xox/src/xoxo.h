#include "pointList.h"

typedef enum {GAME_RUN, GAME_WIN} Status;
typedef char Tile;
typedef Tile **TileMatrix;
typedef struct {
  int boardDim;
  TileMatrix board;
  int sizeXY;
  int margin;
  int cellSpace;
  char xoturn;
  pointList winLine;
  Status status;
  Tile winner;
} GameState;
#define XTILE 'x'
#define OTILE 'o'
#define VOID_TILE '.'

GameState gs;

void game_init(int boardDim);
void ox_debug_print_board();
void fcolor(long c);
Tile checkWin();

#define X_WIN 1
#define O_WIN 2
#define BOARD_SIZE 8
#define TOWIN 5

int checkWinOne(int x, int y);

void drawOTile(int x, int y, int c, int m);
void drawXTile(int x, int y, int c, int m);

void gameStep(float x, float y);

#define GAME_WINDOW_H 500
#define BOARD_H GAME_WINDOW_H / 2 + GAME_WINDOW_H / 6
