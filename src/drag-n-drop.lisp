(defun drag-and-drop-with-mouse ()
  (let ((rect-width 100)
        (rect-height 100)
        (rect-x 50)
        (rect-y 50)
        (dragging nil)
        (drag-offset-x 0)
        (drag-offset-y 0))
    (sdl:with-init ()
      (sdl:window 400 400 :title-caption "Drag and Drop Example")
      (setf (sdl:frame-rate) 60)
      (sdl:with-events ()
        (:quit-event () t)
        (:key-down-event (:key key)
         (when (eq key :sdl-key-escape)
           (sdl:push-quit-event)))

        ;; Start Dragging
        (:mouse-button-down-event (:x x :y y)
         (when (and (>= x rect-x)
                    (< x (+ rect-x rect-width))
                    (>= y rect-y)
                    (< y (+ rect-y rect-height)))
           (setf dragging t)
           (setf drag-offset-x (- x rect-x))
           (setf drag-offset-y (- y rect-y))))

        ;; Stop Dragging
        (:mouse-button-up-event ()
         (setf dragging nil))

        ;; Update Rectangle Position While Dragging
        (:mouse-motion-event (:x x :y y)
         (when dragging
           (setf rect-x (- x drag-offset-x))
           (setf rect-y (- y drag-offset-y))))

        ;; Render Loop
        (:idle ()
         (sdl:clear-display (sdl:color :r 255 :g 255 :b 255))
         ;; Rechteck zeichnen
         (sdl:draw-box (sdl:rectangle rect-x rect-y rect-width rect-height)
                       :color (sdl:color :r 100 :g 100 :b 255))
         (sdl:update-display))))))


