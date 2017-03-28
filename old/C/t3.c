#include <ncurses.h>
//xdg-open wget
int main(int argc,char *argv[]){
      initscr();
      move(10,30);
      printw("Hello world !!!");
      
      chtype ch = 'w' | A_BOLD;
      move(5,5);
      addch(ch);
      
      start_color();
      init_pair(1, COLOR_RED, COLOR_BLACK);
      init_pair(2, COLOR_GREEN, COLOR_YELLOW);
      chtype ch2 = 'w' | COLOR_PAIR(1);
      addch(ch2);
      
      //addchnstr(,-1);
      addstr("******");
      
      attrset(A_NORMAL);
      attron(COLOR_PAIR(2));
      addstr("******");
      attron(COLOR_PAIR(1));
      int x,y;
      getyx(stdscr, x, y);
      printw("x: %d y: %d",x,y);
      mvprintw(19,2,"abracadabra!");
      
      WINDOW* w;
      //init_wins(w,1);
      w = derwin(stdscr,20,40,1,1);
      box(w,0,0);
      
      refresh();
	while((ch = getch()) != 'q')
	{	switch(ch)
		{	case KEY_LEFT:
				break;

    }}
      endwin();
      
}
