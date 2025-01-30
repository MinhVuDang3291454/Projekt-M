(defun handle-mouse-button-down (x y game-state)
    (loop for item in (game-state-items game-state)
            do (when (and (>= x (item-x item))
                        (< x (+ (item-x item) (item-width item)))
                        (>= y (item-y item))
                        (< y (+ (item-y item) (item-height item))))
                (setf (game-state-dragging game-state) t)
                (setf (game-state-current-item game-state) item)
                (setf (game-state-current-item-type game-state) (item-item-type item))
                (setf (game-state-drag-offset-x game-state) (- x (item-x item)))
                (setf (game-state-drag-offset-y game-state) (- y (item-y item)))
                ;; Speichere die ursprünglichen Koordinaten
                (setf (item-old-x item) (item-x item))
                (setf (item-old-y item) (item-y item))))


    (loop for spot in (game-state-inventory-spots game-state)
        do(when (and (>= x (inventory-spot-x spot))
                (< x (+ (inventory-spot-x spot) (inventory-spot-width spot)))
                (>= y (inventory-spot-y spot))
                (< y (+ (inventory-spot-y spot) (inventory-spot-height spot))))
        (setf (game-state-current-item-spot game-state) spot)))



    (loop for spot in (game-state-equipment-spots game-state)
        do(when(and  (>= x (equipment-spot-x spot))
                (< x(+ (equipment-spot-x spot) (equipment-spot-width spot)))
                (>= y (equipment-spot-y spot))
                (< y (+ (equipment-spot-y spot) (equipment-spot-height spot))))
        (setf (game-state-current-equipment-spot game-state) spot)))



    (loop for spot in (game-state-shop-spots game-state)
        do(when(and  (>= x (shop-spot-x spot))
                (< x(+ (shop-spot-x spot) (shop-spot-width spot)))
                (>= y (shop-spot-y spot))
                (< y (+ (shop-spot-y spot) (shop-spot-height spot))))
        (setf (game-state-current-shop-spot game-state) spot)))



    (loop for spot in (game-state-enemy-spots game-state)
        do(when(and  (>= x (enemy-spot-x spot))
                (< x(+ (enemy-spot-x spot) (enemy-spot-width spot)))
                (>= y (enemy-spot-y spot))
                (< y (+ (enemy-spot-y spot) (enemy-spot-height spot))))
        (setf (game-state-current-enemy-spot game-state) spot)
        (setf (game-state-current-target game-state) (enemy-spot-enemy spot))))
6


    (dolist (button (game-state-buttons game-state))
        (when (and (>= x (button-x button))
                  (< x (+ (button-x button) (button-width button)))
                  (>= y (button-y button))
                  (< y (+ (button-y button) (button-height button))))
          (setf (button-pressed button) t))) ;; Button als gedrückt markieren
)       
    




(defun handle-mouse-button-up (x y game-state)
  (let ((current-item (game-state-current-item game-state)))
    (when current-item
    
      
      
      (let ((snapped nil)) ;; Flag, ob das Item gesnappt wurde
        ;; Überprüfe, ob das Item in einen Inventarspot passt
        (dolist (spot (game-state-inventory-spots game-state))
          (when (and (>= x (inventory-spot-x spot))
                    (< x (+ (inventory-spot-x spot) (inventory-spot-width spot)))
                    (>= y (inventory-spot-y spot))
                    (< y (+ (inventory-spot-y spot) (inventory-spot-height spot)))
                    (not (inventory-spot-item spot)))
            ;; Snap das Item zum Spot
            (setf (item-x current-item) (inventory-spot-x spot))
            (setf (item-y current-item) (inventory-spot-y spot))

            ;; Entferne das Item aus dem Equipment-Spot
            (when (game-state-current-equipment-spot game-state)
              (setf (equipment-spot-item (game-state-current-equipment-spot game-state)) nil)
              (setf (entity-equipment (game-state-hero game-state))
                    (remove current-item (entity-equipment (game-state-hero game-state)))))

            ;; Setze das Item in den neuen Inventar-Spot
            (setf (inventory-spot-item spot) current-item)

            ;; Aktualisiere den aktuellen Spot im `game-state`
            (setf (game-state-current-item-spot game-state) spot)
            (setf snapped t)

            ;; Aktualisiere die Stats der `entity` (falls nötig)
            (update-entity-stats (game-state-hero game-state))))



        (dolist (spot (game-state-equipment-spots game-state))
          (when (and (>= x (equipment-spot-x spot))
                    (< x (+ (equipment-spot-x spot) (equipment-spot-width spot)))
                    (>= y (equipment-spot-y spot))
                    (< y (+ (equipment-spot-y spot) (equipment-spot-height spot)))
                    (not (equipment-spot-item spot))
                    (string= (equipment-spot-item-restriction spot) (game-state-current-item-type game-state)))
            ;; Snap das Item zum Spot
            (setf (item-x current-item) (equipment-spot-x spot))
            (setf (item-y current-item) (equipment-spot-y spot))

            ;; Entferne das Item aus dem alten Spot
            (when (game-state-current-equipment-spot game-state)
              (setf (equipment-spot-item (game-state-current-equipment-spot game-state)) nil)
              (setf (entity-equipment (game-state-hero game-state))
                    (remove current-item (entity-equipment (game-state-hero game-state)))))

            (when (game-state-current-item-spot game-state)
              (setf (inventory-spot-item (game-state-current-item-spot game-state)) nil))

            ;; Füge das Item in den neuen Equipment-Spot ein
            (setf (equipment-spot-item spot) current-item)
            (push current-item (entity-equipment (game-state-hero game-state)))

            ;; Aktualisiere den aktuellen Spot im `game-state`
            (setf (game-state-current-equipment-spot game-state) spot)
            (setf snapped t)

            ;; Aktualisiere die Stats der `entity`
            (update-entity-stats (game-state-hero game-state))))

                ;; Wenn kein Snap erfolgt ist, setze die alte Position zurück
                (unless snapped
                  (setf (item-x current-item) (item-old-x current-item))
                  (setf (item-y current-item) (item-old-y current-item)))))
            ;; Beende Dragging-Status
            (setf (game-state-dragging game-state) nil)
            (setf (game-state-current-item game-state) nil))



    "Behandelt das Loslassen der Maustaste und überprüft, ob ein Button geklickt wurde."
    (dolist (button (game-state-buttons game-state))
      (when (button-pressed button)
        ;; Button-Zustand zurücksetzen
        (setf (button-pressed button) nil)

        ;; Überprüfen, ob die Maus noch über dem Button ist
        (when (and (>= x (button-x button))
                  (< x (+ (button-x button) (button-width button)))
                  (>= y (button-y button))
                  (< y (+ (button-y button) (button-height button))))
          ;; Aktion ausführen, falls vorhanden
          (when (button-action button)
            (funcall (button-action button))))))
  )








(defun handle-mouse-motion (x y game-state)
  (when (game-state-dragging game-state)
    (let ((current-item (game-state-current-item game-state)))
      (when current-item
        (setf (item-x current-item) (- x (game-state-drag-offset-x game-state)))
        (setf (item-y current-item) (- y (game-state-drag-offset-y game-state)))))))
