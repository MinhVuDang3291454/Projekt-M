(defun animate-sprites ()
  "Animiert ein Sprite durch das Umschalten von Frames."
  (sdl:with-init ()
    (sdl:window 800 600 :title-caption "Sprite Animation")

    ;; Sprite-Frames laden
    (let* ((sprite1 (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_idle-0-0.png"))
           (sprite2 (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_idle-1-0.png"))
           (sprite3 (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_idle-2-0.png"))
           (sprite4 (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_idle-3-0.png"))
           (frames (list sprite1 sprite2 sprite3 sprite4))
           (current-frame 0)
           (frame-delay 10) ; Anzahl der Frames, bevor umgeschaltet wird
           (frame-counter 0) ; Zähler für die Verzögerung
           (x 100) (y 300) (velocity-x 3))
      
      (sdl:with-events ()
        (:quit-event () t)
        (:idle ()
          ;; Hintergrund löschen
          (sdl:clear-display sdl:*black*)

          ;; Aktuellen Frame zeichnen
          (sdl:draw-surface-at-* (nth current-frame frames) x y)

           ;; Frame-Wechsel alle 10 Frames
          (incf frame-counter)
          (when (>= frame-counter frame-delay)
            (setf current-frame (mod (1+ current-frame) (length frames)))
            (setf frame-counter 0)) ; Zähler zurücksetzen

          ;; Position aktualisieren
          (incf x velocity-x)
          (when (or (> x 700) (< x 0)) (setf velocity-x (- velocity-x)))

          ;; Display aktualisieren
          (sdl:update-display))))))

(defun font-example ()
  (sdl:with-init ()
    (sdl:window 320 300 :title-caption "SDL-TTF Font Example" :icon-caption "SDL-TTF Font Example")
    (setf (sdl:frame-rate) 30)
    (sdl:fill-surface sdl:*white* :surface sdl:*default-display*)
    (unless (sdl:initialise-default-font sdl:*ttf-font-vera*)
      (error "FONT-EXAMPLE: Cannot initialize the default font."))
    (sdl:draw-string-solid-* "Text UTF8 - Solid" 0 50
                             :color sdl:*black*)
    (sdl:draw-string-shaded-* "Text UTF8 - Shaded" 0 150
                              sdl:*black*
                              sdl:*yellow*)
    (sdl:draw-string-blended-* "Text UTF8 - Blended" 0 250
                               :color sdl:*black*)

    (sdl:update-display)
    (sdl:with-events ()
      (:quit-event () t)
      (:video-expose-event () (sdl:update-display))
      (:key-down-event ()
       (when (sdl:key-down-p :sdl-key-escape)
         (sdl:push-quit-event))))))

(font-example)
