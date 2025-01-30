(load "character-info.lisp")
;;(load "item-container.lisp")
;;(load "game-state.lisp")



(defstruct hud
  visible
  inventory-layout
  skill-bar-layout)


(defun rect-array (x y i-width i-height i-size i-distance)
    (loop for inventar-width from 0 to (- i-width 1) do
      (loop for inventar-height from 0 to (- i-height 1) do
        (sdl:draw-rectangle-* 
         (+ x (* inventar-width (+ i-size i-distance))) ; x-coordinate
         (+ y (* inventar-height (+ i-size i-distance))) ; y-coordinate
         i-size ; icon width
         i-size ; icon height
         :color (sdl:color :r 255 :g 255 :b 255)))))


(defun show-item (item)
  "Zeigt ein Item an. Zeichnet entweder ein Icon oder ein Rechteck, wenn kein Icon definiert ist."
  (let ((icon-path (item-icon-path item)))
    (if (and icon-path (probe-file icon-path))
        ;; Wenn ein Icon-Pfad existiert und die Datei verfügbar ist
        (let ((icon (sdl:load-image icon-path)))
          (when icon
            (sdl:draw-surface-at-* icon (item-x item) (item-y item))
            (sdl:draw-rectangle-* (item-x item) (item-y item)
                                (item-width item) (item-height item)
                                :color (sdl:color :r 138 :g 138 :b 138))  
          ))
        ;; Fallback: Zeichne ein Rechteck
        (progn
          (sdl:draw-rectangle-* (item-x item) (item-y item)
                                (item-width item) (item-height item)
                                :color (sdl:color :r 138 :g 138 :b 138))
          (sdl:with-color (random-color (sdl:color :r 138 :g 138 :b 138))
            (sdl:flood-fill-* (+ (item-x item) 2) (+ (item-y item) 2) :surface sdl:*default-display*))))))


(defun test-bmp ()
  (sdl:with-init ()
    (sdl:window 320 320 :title-caption "Simple BMP example")
    (sdl:fill-surface sdl:*white* :surface sdl:*default-display*)

    (let ((img (sdl:load-image "Icons/armor.bmp")))
      (if img
          (progn
            (format t "Rendering image...~%")
            (sdl:draw-surface-at img #(150 150))
            (sdl:update-display)
            (sdl:with-events ()
              (:quit-event () t)
              (:key-down-event ()
               (when (sdl:key-down-p :sdl-key-escape)
                 (sdl:push-quit-event)))))
          (format t "Failed to load image at path: Icons/armor.bmp~%")))))

    
(defun static-hud-test ()
  (let ((width 1980) (height 1080))
    (sdl:with-init ()
      (sdl:window width height
                  :title-caption "random-rect"
                  :icon-caption "random-rect")
      (setf (sdl:frame-rate) 60)
      ;;(add-item)
      

      (sdl:with-events ()
        (:quit-event () t)
        (:key-down-event (:key key)
         (if (sdl:key= key :SDL-KEY-ESCAPE)
           (sdl:push-quit-event)))
        (:idle ()
          (sdl:clear-display sdl:*black*)
          (sdl:draw-rectangle-* 10 10 980 250 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 40 65 140 140 :color (sdl:color :r 255 :g 255 :b 255))       ;;Chrackter Window
          (sdl:draw-rectangle-* 190 80 245 25 :color (sdl:color :r 128 :g 128 :b 128))       ;;Armor Bar
          (sdl:draw-rectangle-* 445 80 245 25 :color (sdl:color :r 230 :g 130 :b 238))       ;;Magic Shield Bar
          (sdl:draw-rectangle-* 190 120 500 25 :color (sdl:color :r 255 :g 000 :b 000))      ;;Health Bar
          (sdl:draw-rectangle-* 190 160 500 25 :color (sdl:color :r 000 :g 000 :b 255))      ;;Mana Bar
          (sdl:draw-rectangle-* 10 260 980 600 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 10 860 980 210 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 990 10 980 850 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 1020 40 920 100 :color (sdl:color :r 255 :g 255 :b 255))     ;;Speed Bar
          (sdl:draw-rectangle-* 990 860 980 210 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 1002 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 1
          (sdl:draw-rectangle-* 1242 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 2
          (sdl:draw-rectangle-* 1482 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 3
          (sdl:draw-rectangle-* 1722 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 4
          (rect-array 350 320 6 5 90 10)                                                     ;;Inventar
          (rect-array 80 420 2 4 90 10)                                                      ;;Equipment
          (rect-array 45 320 4 1 50 20)                                                      ;;Sets

          ;; Test Fill --------------------------------------
          (fill-bar 190 120 500 25 250 500 255 0 0)   	                      ;;Fill HP
          (fill-bar 190 160 500 25 250 500 0 0 255)   	                      ;;Fill Mana
          (fill-bar 190 80 245 25 250 500 128 128 128)   	                    ;;Fill Armor
          (fill-bar 445 80 245 25 250 500 230 130 238)   	                    ;;Fill Magic Shield

          ;;(sdl:draw-rectangle-* 351 321 88 88 :color (sdl:color :r 138 :g 138 :b 138))
          ;;(fill-bar 351 321 88 88 1 1 138 138 138)         
          ;;(:mouse-button-down-event (:x x :y y))
          

          ;;(loop for item in *active-items*
            ;;do(show-item item))
         ;;(show-item (nth 0 *active-items*))
          

         (sdl:update-display))))))




(defun draw-hud-frame ()
  "Zeichnet den Rahmen des HUD."
  (sdl:draw-rectangle-* 10 10 980 250 :color (sdl:color :r 255 :g 255 :b 255)) ;; Main HUD frame
  (sdl:draw-rectangle-* 10 260 980 600 :color (sdl:color :r 255 :g 255 :b 255)) ;; Center frame
  (sdl:draw-rectangle-* 10 860 980 210 :color (sdl:color :r 255 :g 255 :b 255)) ;; Bottom frame
  (sdl:draw-rectangle-* 990 10 980 850 :color (sdl:color :r 255 :g 255 :b 255)) ;; Right frame
  (sdl:draw-rectangle-* 990 860 980 210 :color (sdl:color :r 255 :g 255 :b 255))) ;; Bottom-right frame

(defun draw-character-info ()
  "Zeichnet die Charakterinformationen."
  (sdl:draw-rectangle-* 40 65 140 140 :color (sdl:color :r 255 :g 255 :b 255))) ;; Character window

(defun draw-status-bars (hero)
  "Zeichnet Status-Bars (HP, Mana, Rüstung, Magisches Schild) basierend auf der `stats`-Struktur des Helden."
  (let ((stats (entity-stats hero)))
    (fill-bar 190 120 500 25 (stats-current-hp stats) (stats-max-hp stats) 255 0 0) ;; HP-Bar
    (fill-bar 190 160 500 25 (stats-current-ressource stats) (stats-max-ressource stats) 0 0 255) ;; Mana-Bar
    (fill-bar 190 80 245 25 (stats-current-armor stats) (stats-max-armor stats) 128 128 128) ;; Armor-Bar
    (fill-bar 445 80 245 25 (stats-current-magical-shield stats) (stats-max-magical-shield stats) 230 130 238))) ;; Magic Shield Bar


(defun draw-inventory (items)
  "Zeichnet das Inventar basierend auf den übergebenen Items."
  (rect-array 350 320 6 5 90 10)
  (loop for item in items
        do (show-item item)))

(defun draw-equipment (game-state)
  
  "Zeichnet die Equipment-Spots mit festen Positionen."
  (let* ((icon-helm (sdl:load-image "Icons/HELM.bmp"))
         (icon-chest (sdl:load-image "Icons/CHEST.bmp"))
         (icon-hands (sdl:load-image "Icons/HANDS.bmp"))
         (icon-boots (sdl:load-image "Icons/BOOTS.bmp"))
         (icon-amulet (sdl:load-image "Icons/AMULET.bmp"))
         (icon-weapon (sdl:load-image "Icons/WEAPON.bmp"))
         (icon-offhand (sdl:load-image "Icons/OFFHAND.bmp"))
         (icon-ring (sdl:load-image "Icons/RING.bmp")))

    ;; Zeichenlogik für die festen Slots
    ;; Slot 1: Helm
    (when (and (null (equipment-spot-item (nth 0 (game-state-equipment-spots game-state))))
               icon-helm)
      (sdl:draw-surface-at icon-helm #(80 420)))
    
    ;; Slot 2: Chest
    (when (and (null (equipment-spot-item (nth 1 (game-state-equipment-spots game-state))))
               icon-chest)
      (sdl:draw-surface-at icon-chest #(80 520)))
    
    ;; Slot 3: hands
    (when (and (null (equipment-spot-item (nth 2 (game-state-equipment-spots game-state))))
               icon-hands)
      (sdl:draw-surface-at icon-hands #(80 620)))
    
    ;; Slot 4: Boots
    (when (and (null (equipment-spot-item (nth 3 (game-state-equipment-spots game-state))))
               icon-boots)
      (sdl:draw-surface-at icon-boots #(80 720)))
    
    ;; Slot 5: Amulet
    (when (and (null (equipment-spot-item (nth 4 (game-state-equipment-spots game-state))))
               icon-amulet)
      (sdl:draw-surface-at icon-amulet #(180 420)))
    
    ;; Slot 6: Weapon
    (when (and (null (equipment-spot-item (nth 5 (game-state-equipment-spots game-state))))
               icon-weapon)
      (sdl:draw-surface-at icon-weapon #(180 520)))
    
    ;; Slot 7: Offhand
    (when (and (null (equipment-spot-item (nth 6 (game-state-equipment-spots game-state))))
               icon-offhand)
      (sdl:draw-surface-at icon-offhand #(180 620)))
    
    ;; Slot 8: Ring
    (when (and (null (equipment-spot-item (nth 7 (game-state-equipment-spots game-state))))
               icon-ring)
      (sdl:draw-surface-at icon-ring #(180 720))))
    (rect-array 80 420 2 4 90 10) )

(defun draw-set ()
  (rect-array 45 320 4 1 50 20))

(defun draw-shop ()
  (rect-array 80 920 5 1 90 30))

(defun draw-speed-bar ()
  (sdl:draw-rectangle-* 1020 40 920 100 :color (sdl:color :r 255 :g 255 :b 255))
)

(defun draw-skill-bar ()
  (sdl:draw-rectangle-* 1002 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 1
  (sdl:draw-rectangle-* 1242 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 2
  (sdl:draw-rectangle-* 1482 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 3
  (sdl:draw-rectangle-* 1722 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 4
)

(defun draw-buttons (game-state)
  "Zeichnet alle Buttons im Spielzustand."
  (dolist (button (game-state-buttons game-state))
    (let ((color (if (button-pressed button)
                     (sdl:color :r 0 :g 128 :b 255) ;; Blau für gedrückt
                     (sdl:color :r 255 :g 255 :b 255)))) ;; Weiß für normal
      (sdl:draw-rectangle-* (button-x button)
                          (button-y button)
                          (button-width button)
                          (button-height button)
                          :color color
                          )))) 


(defun draw-target-enemy (game-state)
  (let ((current-enemy-spot (game-state-current-enemy-spot game-state)))
    (when current-enemy-spot
      ;; Rendern eines roten Rahmens um den Spot
      (let ((x (enemy-spot-x current-enemy-spot))
            (y (enemy-spot-y current-enemy-spot))
            (width (enemy-spot-width current-enemy-spot))
            (height (enemy-spot-height current-enemy-spot)))
        (sdl:draw-rectangle-* x y width height
                            :color (sdl:color :r 255 :g 0 :b 0)))))) ;; Roter Rahmen

(defun render-hud (game-state)
  "Render das gesamte HUD basierend auf dem aktuellen Spielstatus."
  (draw-hud-frame)
  (draw-equipment game-state)
  (draw-character-info)
  (draw-status-bars (game-state-hero game-state)) ;; Hero wird direkt übergeben
  (draw-inventory (game-state-items game-state)) ;; Items direkt aus game-state
  (draw-set)
  (draw-shop)
  (draw-speed-bar)
  ;; (draw-skill-bar)
  (draw-buttons game-state))





