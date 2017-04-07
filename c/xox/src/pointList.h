struct pointNode {
  int x;
  int y;
  struct pointNode *next;
} pointNode;

typedef struct pointNode *pointList;

void freePointList(pointList list);
pointList addPointList(pointList list, int x, int y);
void printPointList(pointList list);
