(define (script-fu-add-anim-layer img)
; 
(let* (

        (layer (car (gimp-image-get-active-layer img)))
        (laynew (gimp-layer-new img (car (gimp-image-width img)) (car (gimp-image-height img)) RGBA-IMAGE "name" 100 LAYER-MODE-NORMAL))
        (layers (gimp-image-get-layers img))
        (num-layers (car layers))
        (layer-array (cadr layers))
        (prevlayer (aref layer-array 1))
        ;(prevlayer (aref layer-array (- num-layers 1)))
       )

    (gimp-image-undo-group-start img)
    (gimp-context-push)
    (gimp-layer-set-opacity layer 50)
    (if (> num-layers 2) (gimp-layer-set-visible prevlayer FALSE) 0)
    (if (> num-layers 2) (gimp-layer-set-opacity prevlayer 100) 0)
    (gimp-image-add-layer img (car laynew) 0)

    (gimp-context-pop)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
    ;(gimp-message "0")
  )

  )
(script-fu-register
"script-fu-add-anim-layer" "Add layer and hide 2 below and opacity 50" "" "Ksihe" "" "May 27, 2020" ""                     
SF-IMAGE       "Image"              0
)
(script-fu-menu-register "script-fu-add-anim-layer" "<Image>/Filters/Ksihe")
