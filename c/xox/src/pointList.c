#include <stdlib.h>
#include <stdio.h>
#include "pointList.h"

void freePointList(pointList list) {
  pointList previousNode, currentNode = list;
  if (!list) return;
  do {
    previousNode = currentNode;
    currentNode = previousNode->next;
    free(previousNode);
  } while (currentNode);
}


pointList addPointList(pointList list, int x, int y) {
  pointList node = malloc(sizeof(pointNode));
  node->x = x;
  node->y = y;
  node->next = list;
  return node;
}

void printPointList(pointList list) {
  pointList node = list;
  if (!list) return;
  do {
    printf("[%i %i] ", node->x, node->y);
  } while (node = node->next);
  puts("\n");
}


// TEST
/*
int main(){
  pointList a = 0;
  a = addPointList(a, 3, 2);
  a = addPointList(a, 33, 92);
  a = addPointList(a, 33, 92);
  a = addPointList(a, 2, 2000);
  printPointList(a);
  freePointList(a);
  a = 0;
  printPointList(a);
  a = addPointList(a, 33, 92);
  printPointList(a);
  return 0;
}

*/
