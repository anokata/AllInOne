#include <gtk/gtk.h>
gint configure_event (GtkWidget *widget, GdkEventConfigure *event);
gboolean button_press_event(GtkWidget *widget, GdkEventButton *event);
gboolean expose_event_callback (GtkWidget *widget, GdkEventExpose *event, gpointer data);

void drawTiles();
void drawBoard();
void fcolor(long c);
void updateLabelInfo(char *t);

GtkWidget *labTurn;
