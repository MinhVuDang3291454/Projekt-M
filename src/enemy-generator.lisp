                     ;;(generate-skeleton 1100 200)  
                     ;;(generate-skeleton 1400 200)
                     ;;(generate-skeleton 1700 200)
                     ;;(generate-skeleton 1250 500)
                     ;;(generate-skeleton 1550 500)

(defun generate-enemy (enemy-type x y)
  "Erzeugt einen Gegner als `entity` an den angegebenen Koordinaten."
  ;; Sicherstellen, dass die Animationen geladen sind
  (initialize-enemy-animations)
  ;; Animationen für den Gegnertyp abrufen
  (let ((animations (gethash enemy-type *enemy-animations*)))
    (unless animations
      (error "Keine Animationen für Gegnertyp ~A gefunden." enemy-type))
    ;; Erzeuge die Entity mit der :idle-Animation
    (make-entity
     :name enemy-type
     :entity-type :enemy
     :stats (make-stats :max-hp 100 :current-hp 100 :speed 2) ;; Beispielwerte
     :abilities nil ;; Falls der Gegner spezifische Fähigkeiten hat
     :status nil
     :x x
     :y y
     :sprite-frames (getf (gethash :idle animations) :frames) ;; Frames der Idle-Animation
     :current-frame 0
     :frame-delay 3
     :frame-counter 0
     :animation-type :idle)))


(defun initialize-enemy-animations ()
  (initialize-skeleton-animations)
)