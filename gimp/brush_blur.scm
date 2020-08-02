(define (script-fu-ksi-set-brush-for-blur img)
; select brush and settings
    (gimp-context-set-brush "Kblur")
    (gimp-context-set-brush-size 75)
    (gimp-context-set-brush-aspect-ratio 0)
    (gimp-context-set-brush-angle 0)
    (gimp-context-set-brush-spacing 0.05)
    (gimp-context-set-brush-hardness 0)
    (gimp-context-set-brush-force 1)
    (gimp-context-set-dynamics "Kdyn_Skulpt")
    (gimp-context-set-opacity 100)
  )

(script-fu-register
"script-fu-ksi-set-brush-for-blur" "Select blur brush" "" "Ksihe" "" "Aug 02, 2020" ""                     
SF-IMAGE       "Image"              0
)
(script-fu-menu-register "script-fu-ksi-set-brush-for-blur" "<Image>/Filters/Ksihe")
