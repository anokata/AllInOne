//gcc -S -masm=intel
typedef signed int Int;
typedef unsigned char Char;
typedef signed long int Integer;
typedef signed int* pInt; typedef signed int* IntPtr;
typedef unsigned char* String;
//typedef () Func;
#define m(x,y) x##y
#define An(x) x##x
#define Array(s) [s]
#define Arrayt(name,type,size) type name [size];
#define var(name,type) type name;
Int k Array(10);
Arrayt(z,Char,10)
#include <stdarg.h>

struct S1{ int x; int y;} a;
struct S1 b = { 10};
/*
#define templateSum(type)  type sum##type(type x, type y) { return x + y;}
templateSum(int); //get sumint
templateSum(long);// get sumlong
*/

#include <stdio.h>

#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"
#define KRESET "\033[0m"
#define RESET		0
#define BRIGHT 		1
#define DIM		2
#define UNDERLINE 	3
#define BLINK		4
#define REVERSE		7
#define HIDDEN		8

#define BLACK 		0
#define RED		1
#define GREEN		2
#define YELLOW		3
#define BLUE		4
#define MAGENTA		5
#define CYAN		6
#define	WHITE		7
// enum !!
void textcolor(int attr, int fg, int bg);

void textcolor(int attr, int fg, int bg)
{	char command[13];

	/* Command is the control command to the terminal */
	sprintf(command, "%c[%d;%d;%dm", 0x1B, attr, fg + 30, bg + 40);
	printf("%s", command);
}

int main()
{
  printf(KRED "red\n" KRESET);
  printf(KGRN "green\n" KRESET);
  printf(KYEL "yellow\n" KRESET);
  printf(KBLU "blue\n" KRESET);
  printf(KMAG "magenta\n" KRESET);
  printf(KCYN "cyan\n" KRESET);
  printf(KWHT "white\n" KRESET);
  printf(KNRM "normal\n" KRESET);

  printf("This is " KRED "red" KRESET " and this is " KBLU "blue" KRESET "\n");
  
  	textcolor(BRIGHT, RED, BLACK);	
	printf("In color\n");
	textcolor(RESET, WHITE, BLACK);
  int x = 3 | 8;
  return 0;
}

//int main(){0;}
