#include <gtk/gtk.h>
#include "xoxogdk.h"
#include "xoxo.h"

GdkPixmap *pixmap = NULL;
GdkGC *gc;


void updateLabelInfo(char *t) {
  gtk_label_set_text(GTK_LABEL(labTurn), t);
}

void drawXTile(int x, int y, int c, int m) {
  int s = c / 4;
  gdk_gc_set_line_attributes(gc, 3, GDK_LINE_SOLID, GDK_CAP_ROUND, GDK_JOIN_MITER);
  gdk_draw_line(pixmap, gc, x * c + m + s, y * c + m + s,
                (x + 1) * c + m - s, (y + 1) * c + m - s);
  gdk_draw_line(pixmap, gc, (x + 1) * c + m - s, y * c + m + s,
                x * c + m + s, (y + 1) * c + m - s);
}

void drawOTile(int x, int y, int c, int m) {
  gdk_draw_arc(pixmap, gc, TRUE, x * c + c / 2 , y * c + c / 2, c / 2, c / 2, 0, 360*64);
}

gboolean button_press_event(GtkWidget *widget, GdkEventButton *event)
{
  if (event->button == 1 && pixmap != NULL) {
    gameStep(event->x, event->y);
  }
  return TRUE;
}

void fcolor(long c) {
  GdkColor cl;
  cl.pixel = c;
  gdk_gc_set_foreground(gc, &cl);
}

gboolean expose_event_callback (GtkWidget *widget, GdkEventExpose *event, gpointer data) {
  GdkRectangle update_rect;
  update_rect.x = 0;
  update_rect.y = 0;
  update_rect.width = gs.sizeXY + gs.margin * 2;
  update_rect.height = gs.sizeXY + gs.margin * 2;
  GdkColor color;

  gc = gdk_gc_new(widget -> window);

  drawBoard();
  drawTiles();

  // End draw all.
  gdk_draw_pixmap(widget->window,
                  widget->style->fg_gc[GTK_WIDGET_STATE (widget)],
                  pixmap,
                  event->area.x, event->area.y,
                  event->area.x, event->area.y,
                  event->area.width, event->area.height);

  gtk_widget_draw (widget, &update_rect);

  return TRUE;
}

/* Создание нового backing pixmap соответствующего размера */
gint configure_event (GtkWidget *widget, GdkEventConfigure *event) {
  if (pixmap)
    gdk_pixmap_unref(pixmap);
  pixmap = gdk_pixmap_new(widget->window,
                          widget->allocation.width,
                          widget->allocation.height,
                          -1);
  gdk_draw_rectangle (pixmap,
                      widget->style->white_gc,
                      TRUE,
                      0, 0,
                      widget->allocation.width,
                      widget->allocation.height);
  return TRUE;
}

void drawBoard() {
  int space = gs.cellSpace;
  int cols = gs.boardDim;
  int startY = gs.margin;
  int h = gs.sizeXY;
  fcolor(0xFF000000);
  // draw horizontal line - const y1=y2
  for (int x=0; x < cols + 1; x++)
    gdk_draw_line(pixmap, gc, startY, space * x + startY, h,  space * x + startY);

  // draw vertial lines - const x1=x2=current, y1 from start to end
  for (int x=0; x < cols + 1; x++)
    gdk_draw_line(pixmap, gc, space * x + startY, startY, space * x + startY, h);

}

void drawTiles() {
  fcolor(0xFF001188);
  int s = gs.cellSpace / 4;
  for (int x=0; x < gs.boardDim; x++)
    for (int y=0; y < gs.boardDim; y++) {
     if (gs.board[x][y] == OTILE)
      drawOTile(x, y, gs.cellSpace, gs.margin);
    else if (gs.board[x][y] == XTILE) {
      drawXTile(x, y, gs.cellSpace, gs.margin);
    }
  }
  if ((gs.status == GAME_WIN) && gs.winLine) {
    pointList p = gs.winLine;
    fcolor(0xFFFF1100);
    do {
      if (gs.winner == XTILE) drawXTile(p->x, p->y, gs.cellSpace, gs.margin);
      if (gs.winner == OTILE) drawOTile(p->x, p->y, gs.cellSpace, gs.margin);
      p = p->next;
    } while (p);
  }
}


