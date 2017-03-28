#strobo
package require nmea

label .n -width 40 -height 4 -bg white
entry .e -textvar time
set time 100
button .b -command {pack forget .e .b; .n configure -width 140 -height 40; every $time t}
pack .n .e .b
proc every {ms body} {
    if 1 $body
    after $ms [list after idle [info level 0]]
}
set flag 0
puts $flag
proc w {} {.n configure -bg black }
proc b {} {.n configure -bg white }

proc t {} {
        global flag
        if {$flag == 0} {w; set flag 1} else {b; set flag 0}
}

