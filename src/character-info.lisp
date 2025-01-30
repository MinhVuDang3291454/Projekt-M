;;(ql:quickload :lispbuilder-sdl)

(defun fill-bar (x y width height current-amount max-amount r g b)
  ;;Fill a Bar with "flood-fill"
  (let* ((normalized-value (if (> max-amount 0)
                            (/ (float current-amount) max-amount)
                            0))
                     (hp-width (floor (* width normalized-value)))
                     (hp-rect (sdl:draw-rectangle-* x  y hp-width height :color (sdl:color :r r :g g :b b)))     
                     (background-rect (sdl:draw-rectangle-* x y width height)))
                     (if (and (> current-amount 0)
                            (> max-amount 0))
                     (sdl:with-color (random-color (sdl:color :r r :g g :b b))
                     (sdl:flood-fill-* (+ x 1) (+ y 1) :surface sdl:*default-display*)))

    ))