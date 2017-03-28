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

struct DownloadList {
    struct Listnode* next;
    DownloadEntry* data; };
typedef struct DownloadList* List;
//ToImplement: isEndList atIndex create? destroyAll deleteNode insertNode addtoend addtobegin /push pop tail fmap


List makeListElem(DownloadEntry data){
    List l = malloc (sizeof(struct Listnode));
    l->next = NULL;
    l->data = data;
    return l;
};

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

    readFile(downloadfile);
    0;}
