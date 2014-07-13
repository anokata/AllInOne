set f [open "./.downloads" r]
set cont [read $f]
#puts $cont
close $f

set conts ""
for {set i 0} {$i<[llength $cont]} {incr i} {
set conts [concat $conts "\{[lindex $cont "$i"] [lindex $cont "[incr i]"] [lindex $cont "[incr i]"] \}"]
#puts $i
}
#puts $conts

button .add -text "add"
listbox .list -width 30 -listvariable conts
pack .add .list

toplevel .dialogAdd.add
pack .dialogAdd.add
