#include <ncurses.h>
int main(int argc,char *argv[]){
      initscr();
      move(10,30);
      printw("Hello world !!!");
      refresh();
      getch();
      endwin();
      
}
