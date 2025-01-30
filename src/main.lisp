;;(ql:quickload "lispbuilder-sdl")
;;(ql:quickload "lispbuilder-sdl-ttf")

;; src/main.lisp
(load "game-state.lisp")
(load "action.lisp")
(load "character.lisp")
(load "animation.lisp")
(load "hud.lisp")
(load "input-events.lisp")
(load "item-templates.lisp")
(load "shop-generator.lisp")
(load "skeleton-enemy.lisp")
(load "enemy-generator.lisp")
(load "combat-system.lisp")



(defparameter *game-state* nil "Globale Variable für den aktuellen Spielzustand.")


(defun main-loop ()
  "Hauptschleife für das Spiel (lokaler Zustand)."
  (sdl:with-init ()
    ;; SDL initialisieren
    (sdl:window 1980 1080 :title-caption "Project M")
    (setf (sdl:frame-rate) 60)

    (initialize-skeleton-animations)
    ;; Game-State initialisieren
    (setf *game-state*
          (make-game-state
          :hero (make-entity-hero) ;; Helden-Entity erstellen
          :items (list
                  (make-item :name "Brust-Panzer"
                              :id 4
                              :x 650
                              :y 320
                              :old-x 650
                              :old-y 320
                              :item-type "CHEST"
                              :icon-path "Item-Icons/armor/torso/plate_1.png"
                              :stats (make-stats :max-physical-defense 100)))
          :dragging nil
          :drag-offset-x 0
          :drag-offset-y 0
          :current-item nil
          :current-item-spot nil
          :current-equipment-spot nil
          :current-item-type nil
          :current-shop-spot nil
          :inventory-spots (generate-inventory-spots 350 320 6 5 90 10)
          :equipment-spots (generate-equipment-spots 80 420 2 4 90 10)
          :shop-spots (generate-shop-spots 80 920 5 1 90 30)
          :enemies (list
                    (generate-enemy "Skeleton" 1100 250)  ;; Spot 1
                    (generate-enemy "Skeleton" 1250 250)  ;; Spot 2
                    (generate-enemy "Skeleton" 1400 250)  ;; Spot 3
                    (generate-enemy "Skeleton" 1550 250)  ;; Spot 4
                    (generate-enemy "Skeleton" 1700 250)  ;; Spot 5
                    (generate-enemy "Skeleton" 1100 500)  ;; Spot 6
                    (generate-enemy "Skeleton" 1250 500)  ;; Spot 7
                    (generate-enemy "Skeleton" 1400 500)  ;; Spot 8
                    (generate-enemy "Skeleton" 1550 500)  ;; Spot 9
                    (generate-enemy "Skeleton" 1700 500)  ;; Spot 10
                    ) 
          :enemy-spots (generate-all-enemy-spots)
          :current-enemy-spot nil
          :current-target nil
          :buttons (list
                    (generate-button 700 100 90 90
                                      (lambda ()
                                        (print-entity-stats (game-state-hero *game-state*)))))
          :current-turn-entity nil
          :current-action nil
          :frame-timer 0 
          :turn-queue nil
          :round-number 0  
          ))

    (generate-shop-items *game-state*)
    (fill-enemy-spots *game-state*)

    (switch-hero *game-state* (make-entity-hero-mage *game-state*))

    ;; Ereignisschleife
    (sdl:with-events ()
      (:quit-event () t)
      (:key-down-event (:key key)
       (when (eq key :sdl-key-escape)
         (sdl:push-quit-event)))
      (:mouse-button-down-event (:x x :y y)
        (handle-mouse-button-down x y *game-state*))

      (:mouse-button-up-event (:x x :y y)
        (handle-mouse-button-up x y *game-state*))

      (:mouse-motion-event (:x x :y y)
        (handle-mouse-motion x y *game-state*))

      (:idle ()
        ;; Hintergrund löschen
        (sdl:clear-display sdl:*black*)

        ;; HUD rendern
        (render-hud *game-state*)

        ;; Gegner rendern
        (render-enemies *game-state*)

        (draw-target-enemy *game-state*)

        ;; Kampf starten
        ;;(check-combat *game-state*)

        ;; Display aktualisieren
        (sdl:update-display)))))


(main-loop)

