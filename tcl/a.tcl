#package require tcl3d
package require struct::set
puts {a}
set a b
puts $a
set $a c ;# in $a = b be c
puts $b
set c d
set $a $c
puts "c=$c a=$a b=$b "
set dd e
set $dd f
set $$dd g
puts [set $$dd]
puts {[set $dd]}
puts "{$a}"
puts \[\n\]
set x "ffd"
puts $x
set z {[set x "Эта строка в кавычках внутри квадратных скобок."]}
puts "Помните о фигурных скобках: $z\n"
set a "[set x {Эта строка в фигурных скобках внутри кавычек.}]"
puts "В данном случае команда set выполняется: $a"
puts "значение \$x : $x\n"

set b "\[set y {Эта строка в фигурных скобках внутри кавычек.}]"
puts "Помните, \\ обратная дробь отключает скобки:\nзначение \$b : $b"
puts [expr \x32 == 0x2]
puts [expr {80.08e2 **0.23 / exp(1.3)}]

puts {$Z_LABEL [expr $Y + $X]}
puts " {[expr 1 + 2]}"

set x abc
switch $x ab "puts ab" default "puts no"
if {$x=="abc"} {puts "==abc"} else {puts "noever"}

proc sum {a b {def 4}} {
    return [expr 4*($a + $b)] }

puts [sum 3 8]

set acc ":"
for {set i 0} {$i<100} {incr i} {set acc $acc-$i}
#puts $acc

proc Letter {text} {
	if {[regexp {[^a-za-я]} $text]} {
		.a configure -bg red
		return 0
	} else {
		.a configure -bg white
		return 1}}

puts [ttk::style theme names]
puts [ttk::style theme use]
ttk::style theme use alt
puts [ttk::style theme use]
ttk::style configure TButton -font "helvetica 14" -foreground "#FFEECC" -background "#223344" -padding 1 -activebackground "#001122" -activeforeground "#001122"
set styleM { -foreground "#FFEECC" -background "#223344" -activebackground "#001122" -activeforeground "#001122"}
set date [exec date]
wm title . "Hi"
label .hi -text "Привет, Мир!"
button .ex -text Выход -command exit  -relief flat 
button .ex2 -textvariable date -command {pack .hi .ex .ex2 .ex$i -expand yes -fill both} -relief flat
label .clock -textvar time  -foreground "#FFEECC" -background "#223344" -activebackground "#001122" -activeforeground "#001122"
ttk::button .ex4 -text "Hello" -style "Fun.TButton" 
pack .hi .ex .ex2 .ex4 .clock -expand yes -fill none -anchor w
set i 3
button .ex$i -text Title -command {wm title . $i} -relief flat

proc every {ms body} {
    if 1 $body
    after $ms [list after idle [info level 0]]
}
every 1000 {set ::time [clock format [clock sec] -format %H:%M:%S]}
every 1000 {set ::date [exec date]}
every 100 {.ex3 configure -text [format "%c" [expr round(rand() * 30 + 0x40)] ]}

.ex3 configure -relief flat

puts [format "%c" [expr round(rand() * 30 + 0x40)] ]

foreach {id day} { 1 Понедельник
 2 Вторник 3 Среда 4 Четверг
 5 Пятница 6 Суббота 7 Воскресенье
} {
	pack [label .l$id -text $day] -anchor w
}

set a ""
label .la -text {Маленькие буквы:}

entry .a -bg white -textvariable a \
	 -invcmd bell -validate all -vcmd {Letter %P}

pack .la .a -fill x -anchor w

proc Digit {text} {
	if {[regexp {[^0-9]} $text]} {
		.d configure -bg red
		return 0
	} else {
		.d configure -bg white
		return 1
	}
}

label .ld -text {Цифры:}
entry .d -bg white -textvariable d \
	-invcmd bell -validate all -vcmd {Digit %P}

pack .ld .d -fill x -anchor w
bind . <Key-q> {exit}

#string map $list $input

place [text .textbox] -x 200 -width 200 -height 250
place [label .res -text "result:" -textvar result] -x 200 -y 250
place [button .run -text "Run" -command runsubs] -x 200 -y 270
wm resizable . 0 0
wm geometry . "=500x400+0+0"

proc runsubs {} {
    set cont [.textbox dump -text "0.0" "end"]
    .textbox dump -text -command textget "0.0" "end"
    set cont2 [.textbox get "0.0" "end"]
    set rules [string range $cont2 0 [string first "\n->\n" $cont2]]
    set init  [string range $cont2 [expr 3+[string first "\n->\n" $cont2]] "end"]
    set rules2 [lsearch -all -inline -not [string map {"->" " -> " } $rules] "->"]
    set result [string map $rules2 $init]
    puts IS:$result
    set res2 [lsearch -all -inline -not $result "\n"]
    puts :$res2
    #puts [array exists cont]
    #puts [lindex $cont 1]
    #array set conta $cont
    #puts [array exists conta]
    #puts [array names conta]
    #foreach i $cont {puts >>$i}
    #set ::result "f"
    set ::result $res2
    return $res2
}

set l [list a b c]
puts $l
puts [lindex $l 1]

.textbox insert "0.0" "(start)->nn \n(end)->kk\n->\n(start)J(end)"

proc textget {k v i} {
    puts =$v;
}

puts $auto_path
#package require http
