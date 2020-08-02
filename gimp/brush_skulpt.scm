(define (script-fu-ksi-set-brush-for-skulpt img)
; select brush and settings
    (gimp-context-set-brush "mybrush1")
    (gimp-context-set-brush-size 55)
    (gimp-context-set-brush-spacing 0.05)
    (gimp-context-set-brush-hardness 0.9)
    (gimp-context-set-brush-force 1)
    (gimp-context-set-dynamics "Kdyn_Skulpt")

    (gimp-context-set-opacity 100)
    (gimp-context-set-brush-aspect-ratio 0)
    (gimp-context-set-brush-angle 0)
  )

(script-fu-register
"script-fu-ksi-set-brush-for-skulpt" "Select skulpt brush" "" "Ksihe" "" "Aug 02, 2020" ""                     
SF-IMAGE       "Image"              0
)
(script-fu-menu-register "script-fu-ksi-set-brush-for-skulpt" "<Image>/Filters/Ksihe")
