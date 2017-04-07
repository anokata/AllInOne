#include <gtk/gtk.h>
#include "xoxo.h"
#include "xoxogdk.h"

void connectSignals(GtkWidget *window, GtkWidget *drawArea);
GtkWidget *createMainWindow();


int main (int argc, char *argv[]) {
  game_init(BOARD_SIZE);
  gtk_init(&argc, &argv);
  GtkWidget *window = createMainWindow();
  // Create Widgets.
  GtkWidget *drw = gtk_drawing_area_new();
  labTurn = gtk_label_new("Turn:x\n");
  GtkWidget *aButton = gtk_button_new_with_label ("New game.");
  GtkWidget *vbox = gtk_vbox_new(FALSE, 0);
  GtkWidget *vboxbut = gtk_vbox_new(FALSE, 0);
  GtkWidget *hbox = gtk_hbox_new(FALSE, 0);
  gtk_box_pack_start(GTK_BOX(vbox), drw, TRUE, TRUE, 0);
  gtk_box_pack_start(GTK_BOX(vbox), labTurn, FALSE, TRUE, 0);
  gtk_box_pack_start(GTK_BOX(hbox), vbox, TRUE, TRUE, 0);
  gtk_box_pack_start(GTK_BOX(hbox), vboxbut, FALSE, TRUE, 0);
  gtk_box_pack_start(GTK_BOX(vboxbut), aButton, FALSE, FALSE, 0);
  gtk_widget_show(labTurn);
  connectSignals(window, drw);

  gtk_widget_set_events(window,
    GDK_BUTTON_MOTION_MASK  | GDK_BUTTON1_MOTION_MASK |
    GDK_BUTTON_PRESS_MASK);

  gtk_drawing_area_size(GTK_DRAWING_AREA(drw), GAME_WINDOW_H, GAME_WINDOW_H);
  gtk_widget_set_size_request (drw, BOARD_H, BOARD_H);
  gtk_container_add(GTK_CONTAINER(window), hbox);
  gtk_widget_show_all(window);
  puts("Let's run main!");
  gtk_main();
  return 0;
}

GtkWidget *createMainWindow() {
    GtkWidget *window;
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "XOXO");
    gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
    gtk_window_set_default_size(GTK_WINDOW(window), GAME_WINDOW_H, GAME_WINDOW_H);
    return window;
}

void connectSignals(GtkWidget *window, GtkWidget *drawArea) {
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
    g_signal_connect(window, "configure_event", G_CALLBACK(configure_event), NULL);
    g_signal_connect (G_OBJECT (drawArea), "expose_event",
                    G_CALLBACK (expose_event_callback), NULL);
    gtk_signal_connect(GTK_OBJECT(window), "button_press_event",
                     G_CALLBACK(button_press_event), NULL);
}
