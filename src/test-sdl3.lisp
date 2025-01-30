(ql:quickload :lispbuilder-sdl-examples)
(sdl-examples:mouse-2d)

(defun mouse-surface-2d ()
  (sdl:with-init ()
    (sdl:window 200 200 :title-caption "Move a SURFACE using the Mouse.")
    (setf (sdl:frame-rate) 30)

    (sdl:with-surface (movable-surface (sdl:create-surface 20 20))
      (sdl:fill-surface sdl:*white*)

      (sdl:with-events ()
        (:quit-event () t)
        (:mouse-motion-event (:x x :y y)
         ;; Set the texture position with center at the mouse x/y coordinates.
         (sdl:set-surface-* movable-surface
                            :x (- x (/ (sdl:width movable-surface) 2))
                            :y (- y (/ (sdl:height movable-surface) 2))))
        (:key-down-event (:key key)
         (when (eq key :sdl-key-escape)
           (sdl:push-quit-event)))
        (:video-expose-event ()
         (sdl:update-display))
        (:idle ()
         (sdl:clear-display sdl:*black*)
         (sdl:draw-surface movable-surface :surface sdl:*default-display*)
         (sdl:update-display))))))