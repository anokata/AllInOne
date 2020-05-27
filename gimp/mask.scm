(define (script-fu-add-mask-form-selection-below img)
; alpha to selection, new layer, add mask form selection, select layer, remove selection
(let* (

        (layer (car (gimp-image-get-active-layer img)))
        (laynew (gimp-layer-new img (car (gimp-image-width img)) (car (gimp-image-height img)) RGBA-IMAGE "name" 100 LAYER-MODE-NORMAL))
       )

    (gimp-image-undo-group-start img)
    (gimp-context-push)
    (let * (
    (selection (gimp-image-select-item img CHANNEL-OP-ADD layer))
    (mask (gimp-layer-create-mask (car laynew) ADD-MASK-SELECTION))
            )
    (gimp-image-add-layer img (car laynew) 0)
    (gimp-layer-add-mask (car laynew) (car mask))
    (gimp-layer-set-edit-mask (car laynew) 0)
    (gimp-selection-none img)
      )

    (gimp-context-pop)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
    ;(gimp-message "hi3")
  )

  )
(script-fu-register
"script-fu-add-mask-form-selection-below" "Add mask from selection layer below" "" "Ksihe" "" "May 27, 2020" ""                     
SF-IMAGE       "Image"              0
)
(script-fu-menu-register "script-fu-add-mask-form-selection-below" "<Image>/Filters/Ksihe")
