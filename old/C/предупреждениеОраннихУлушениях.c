#include <ncurses.h>
#include "types.h"
#include <stdio.h>
#include <stdlib.h>

String downloadfile = ".downloads";

struct DownloadEntry {
    String url;
    String folderDest;
    Bool completed;
};

// Lists //homogen
struct Listnode {
    struct Listnode* next;
    Pointer data; };
typedef struct Listnode* List;
//ToImplement: isEndList atIndex create? destroyAll deleteNode insertNode addtoend addtobegin /push pop tail fmap

//DeclareListOf (type) ##type //get: TypeList(as struct) makeTypeList...
//List l = makeList( int,);
List makeListElem(Pointer data){
    List l = malloc (sizeof(struct Listnode));
    l->next = NULL;
    l->data = data;
    return l;
};
// да пофиг сейчас. 100 элементов хватит пока.
#define MAXELEMS 100 
struct DownloadEntry downloads [MAXELEMS];
// or maybe unixway? или нафиг в структуры преобразовывать, всеравно же так можно обработать. если уж всё в тексте хранится и текстом выводится. то может одними подстановками и поисками и обойтись? вот смотри, мы преобразуем строки как-то и выводим результат, затем что то меняться должно и снова выводиться. можно менять изначальные данные и заново всё обрабатывать(минус к производительности) можно менять (возможно более сложно) конечные данные (если их хранить заранее) либо хранить цепь преобразований с результатом и изменив часть входных данных пройтись по цепи заново но, работа сделается только для новых данных.
// опишим например такой процесс: читаем файл(строка) -> логический шаг(разбиваем файл на множество строк)т.к. ничего и не надо делать то. [фун кот применяте фун1 к данным построчно \\ фун кот применяет фун1 к данным извлекаемым\разбиваемым функцией2] -> обрабатываем построчно (храним результат) -> выводим \\похоже на ленивость + пайп\ для этого надо спец функцию которая будет так лениво вызывать функции(композировать) точно! надо функцию композиции compf( fun1, fun2)/ хотя проще всё сделать сразу. \\просто напиши грёбаную функцию!

String readFile(String name){
    FILE* f = fopen(name, "r");
    int c;
    /*while ((c = getc(f)) != EOF )
        putc(c, stdout);*/
        
    fclose(f);
};


List addListElem(List l, Pointer data){
    
};

Int main(Int argc, String argv[]){
    /*Pointer d = malloc(sizeof(struct DownloadEntry));
    struct DownloadEntry* e = malloc(sizeof(struct DownloadEntry));
    struct Listnode lhead = {NULL, d}; // makeListElem(Pointer data);*/
    readFile(downloadfile);
    0;}
