puts ("hellow")
a = "a";
a = a + "a"
print (a)
for i in (1..500)
    a = a + i.to_s()
end
puts a[312]
#puts a

puts (0..10).collect{ |v| v ** 2 }.select{ rand(2).zero? }.map.with_index { |*v| v }

require 'gtk2'

class RubyApp < Gtk::Window

    def initialize
        super
    
        set_title "Center"
        signal_connect "destroy" do 
            Gtk.main_quit 
        end

        set_default_size 300, 200

        set_window_position Gtk::Window::Position::CENTER
        
        show
    end
end

Gtk.init
    window = RubyApp.new
Gtk.main
