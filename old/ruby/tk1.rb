require 'tk'

root = TkRoot.new { title 'Hello, World!'; padx 50; pady 15 }
lab = TkLabel.new(root) do
   text 'Hello, World!'
   textvariable $k
   background 'red'
   pack { padx 10 ; pady 10; side 'left' }
end
TkLabel.bind('ButtonPress-1') { lab.configure('background', 'red'); lab.configure('text', 'newtext') }
k='alloha!'
lab.configure('text', 'newtext')
lab.configure('activebackground', 'blue')
lab.configure('background', 'blue')

b2 = TkButton.new(root) {
     text "b2 txt"
     command proc { lab.configure('background', 'green') ; k='x[x'}
     pack {}
}
b3 = TkButton.new(root) {
     text "b3 txt"
     command proc {  k='x[x'}
     pack {}
}
b3.bind("Leave", kc)

def kc
    k="dfdf"
end
kc()

wdgt = TkButton.new(root) {
     text "Click me!"
     command proc { puts "Button of nowhere: I was clicked..." }
     pack {}
}
wdgt.bind("Enter", proc { wdgt.text "Welcome!" })
wdgt.bind("Leave", proc { wdgt.text "Bye!" })

lbl = TkLabel.new(root) { # создаём надпись
     text "Something wasn't clicked yet..." # с таким вот текстом
     pack { padx 100; pady 100; side "left" } # с такими координатами
    }
java_clicked = Proc.new { # ловим клик "Java" в меню
     lbl.text "Java was liked..."}
cs_clicked = Proc.new { # ловим клик "C#" в меню
     lbl.text "C# was liked..."}
cpp_clicked = Proc.new { # ловим клик "C++" в меню
     lbl.text "C++ was liked..."}
py_clicked = Proc.new { # ловим клик "Python" в меню
     lbl.text "Python was liked..."}
rb_clicked = Proc.new { # ловим клик "Ruby" в меню
     lbl.text "Ruby was liked..."}
menu = TkMenu.new(root) # создаём меню

menu.add('command', 'label' => "Java", 'command' => java_clicked) # создаём кнопку "Java"
menu.add('command', 'label' => "C#", 'command' => cs_clicked) # создаём кнопку "C#"
menu.add('separator') # создаём разделитель
menu.add('command', 'label' => "C++", 'command' => cpp_clicked) # создаём кнопку "C++"
menu.add('separator') # создаём разделитель
menu.add('command', 'label' => "Python", 'command' => py_clicked) # создаём кнопку "Python"
menu.add('command', 'label' => "Ruby", 'command' => rb_clicked) # создаём кнопку "Ruby"
bar = TkMenu.new # создаём бар для нашего меню
bar.add('cascade', 'menu' => menu, 'label' => "Click me, I want you!") # добавляем меню в бар
root.menu(bar) # указываем приложению на бар нашего меню

Tk.mainloop

puts {a b}
