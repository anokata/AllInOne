[indent=2]
uses Gtk

def pushBut(button:Button)
  button.label = "Thank you"

const GAME_WINDOW_H : int = 300    
init
  Gtk.init (ref args)
  var window = new Window ()
  window.title = "XOXO"
  window.set_default_size (GAME_WINDOW_H, GAME_WINDOW_H)
  window.position = WindowPosition.CENTER
  window.destroy.connect (Gtk.main_quit)
//  button.clicked.connect(pushBut)

  var drw = new DrawingArea()
  var labTurn = new Label("Turn:x\n")
  var aButton = new Button.with_label("New game.")
  vbox : Box = new VBox(false, 0)
  var vboxbut = new VBox(false, 0)
  var hbox = new HBox(false, 0)
  vbox.pack_start(drw, true, true, 0)
  vbox.pack_start(labTurn, false, true, 0)
  hbox.pack_start(vbox, true, true, 0)
  hbox.pack_start(vboxbut, false, true, 0)
  vboxbut.pack_start(aButton, false, false, 0)
  //window.configure_event.connect(configureEvent)
  //drw.expose_event.connect(expose_event_callback)
  //window.button_press_event.connect(button_press_event)
//  window.set_events(GDK_BUTTON_MOTION_MASK | GDK_BUTTON1_MOTION_MASK | GDK_BUTTON_PRESS_MASK)
//  drw.size(GAME_WINDOW_H, GAME_WINDOW_H)
//  drw.set_size(BOARD_H, BOARD_H)

  window.add(hbox)
  window.show_all ()
  Gtk.main ()
