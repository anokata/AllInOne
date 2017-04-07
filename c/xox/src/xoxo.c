/* TODO
 .. Отображение инфы(количество ходов, время, чей ход, состояние)
 ... Добавлить labels
 ... обновлять их
 ... состояние шагов, история. шаг назад.
 .. Новая игра
 ... с выбором размера поля.
 .. *.о в папку obj
 .. Картинки вместо Х О
 .. изображение на клетки поля
 ... настройка графики.
 ... Сетевое взаимодействие. чат.
 .... переделать. состояние на сервере. клиенты забирают.
 ... Определение ничьей.(все клетки заполнены)
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xoxo.h"
#include "xoxogdk.h"

char lab1[] = "Turn:x\n       ";

void game_init(int boardDim) {
  gs.boardDim = boardDim;
  gs.xoturn = XTILE;
  // if gs.board != NULL   ... free(gs.board)
  gs.board = malloc(sizeof(TileMatrix) * boardDim);
  for (int x = 0; x < boardDim; x++)
    gs.board[x] = malloc(sizeof(TileMatrix) * boardDim);
  // Fill
  for (int x = 0; x < boardDim; x++)
    for (int y = 0; y < boardDim; y++)
    gs.board[x][y] = '.';
  
  gs.board[boardDim / 2][boardDim / 2] = XTILE;
  gs.board[boardDim / 2 - 1][boardDim / 2 - 1] = XTILE;
  gs.board[boardDim / 2][boardDim / 2 - 1] = OTILE;
  gs.board[boardDim / 2 - 1][boardDim / 2] = OTILE;
  gs.status = GAME_RUN;
  gs.margin = 10;
  gs.sizeXY = BOARD_H;
  gs.cellSpace = (gs.sizeXY - gs.margin) / gs.boardDim;
  
  //Strings
//  updateLabelInfo(lab1);
}

int checkWinOne(int x, int y) {
  Tile searchTile = gs.board[x][y];
  int currentLine = 0;
  Tile currentTile = searchTile;
  int i = x;
  int j = y;
  pointList winLine = 0;
  // Find Right
  while (i < gs.boardDim){
    currentTile = gs.board[i][j];
    if (currentTile == searchTile) {
        currentLine++;
        winLine = addPointList(winLine, i, j);
        }
    else break;
    if (currentLine == TOWIN) {
      gs.winLine = winLine;
      gs.winner = searchTile;
      return searchTile;
    }
    i++;
  }
  freePointList(winLine);
  winLine = 0;
  i = x;
  j = y;
  currentLine = 0;
  // Find Down
  while (j < gs.boardDim){
    currentTile = gs.board[i][j];
    if (currentTile == searchTile) {
        currentLine++;
        winLine = addPointList(winLine, i, j);
        }
    else break;
    if (currentLine == TOWIN) {
      gs.winLine = winLine;
      gs.winner = searchTile;
      return searchTile;
    }
    j++;
  }
  freePointList(winLine);
  winLine = 0;
  i = x;
  j = y;
  currentLine = 0;
// Find Dia
  while ((j < gs.boardDim) && (i < gs.boardDim)){
    currentTile = gs.board[i][j];
    if (currentTile == searchTile) {
        currentLine++;
        winLine = addPointList(winLine, i, j);
        }
    else break;
    if (currentLine == TOWIN) {
      gs.winLine = winLine;
      gs.winner = searchTile;
      return searchTile;
    }
    j++;
    i++;
  }
  freePointList(winLine);
  winLine = 0;
  i = x;
  j = y;
  currentLine = 0;
// Find DiaD
  while ((j < gs.boardDim) && (i >= 0)){
    currentTile = gs.board[i][j];
    if (currentTile == searchTile) {
        currentLine++;
        winLine = addPointList(winLine, i, j);
        }
    else break;
    if (currentLine == TOWIN) {
      gs.winLine = winLine;
      gs.winner = searchTile;
      return searchTile;
    }
    j++;
    i--;
  }

  return 0;
}

Tile checkWin(){
  Tile c;
  for (int x=0; x < gs.boardDim; x++)
    for (int y=0; y < gs.boardDim; y++) {
      c = gs.board[x][y];
      if (c != VOID_TILE) {
        int w = checkWinOne(x, y);
        if (w) return w;
      }
    }
  return 0;
}

void ox_debug_print_board() {
  printf("\n");
  for (int x = 0; x < gs.boardDim; x++) {
    for (int y = 0; y < gs.boardDim; y++)
    printf("%c", gs.board[y][x]);
  printf("\n");
  }
}

void gameStep(float x, float y) {
  int i = (int) ((x - gs.margin) / gs.cellSpace);
  int j = (int) ((y - gs.margin) / gs.cellSpace);
  if ((gs.status == GAME_RUN) && (i < gs.boardDim) && (j < gs.boardDim)) {
    if (gs.board[i][j] == VOID_TILE) {
    gs.board[i][j] = gs.xoturn;

    if (gs.xoturn == XTILE)
      gs.xoturn = OTILE;
    else
      gs.xoturn = XTILE;
    }
    lab1[5] = gs.xoturn;
//    lab1[11] = 2 + 0x30;
    updateLabelInfo(lab1);
    
    Tile winner = checkWin();
    if (winner) {
     //printf("WIN! %c !\n", winner);
     gs.status = GAME_WIN;
     char *w = strdup("Winner is _");
     w[10] = winner;
     updateLabelInfo(w);
     free(w);
    }
  }
}





