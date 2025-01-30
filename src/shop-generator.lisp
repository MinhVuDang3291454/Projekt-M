(defun generate-shop-items (game-state)
  "Generiere neue Shop-Items aus den Templates und aktualisiere die Shop-Spots."
  ;; Stelle sicher, dass *ITEM-TEMPLATES* geladen ist
  ;;(unless (boundp '*item-templates*)
   ;; (load "item-templates.lisp"))
  
  (let ((new-items (loop repeat 5
                         collect (nth (random (length *item-templates*)) *item-templates*))))
    ;; Fülle die Shop-Spots mit den neuen Items
    (let ((shop-spots (game-state-shop-spots game-state)))
      (loop for spot in shop-spots
            for item in new-items
            do (progn
                (setf(item-x item) (shop-spot-x spot))
                (setf(item-y item) (shop-spot-y spot))
                (setf(item-old-x item) (shop-spot-x spot))
                (setf(item-old-y item) (shop-spot-y spot))

                 (setf (shop-spot-item spot) item)
                 (push item (game-state-items game-state)))))))
