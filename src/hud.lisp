(ql:quickload :lispbuilder-sdl)

(defun static-hud ()
  (let ((width 1980) (height 1080))
    (sdl:with-init ()
      (sdl:window width height
                  :title-caption "random-rect"
                  :icon-caption "random-rect")
      (setf (sdl:frame-rate) 5)
      (sdl:with-events ()
        (:quit-event () t)
        (:key-down-event (:key key)
         (if (sdl:key= key :SDL-KEY-ESCAPE)
           (sdl:push-quit-event)))
        (:idle ()
          (sdl:draw-rectangle-* 10 10 980 250 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 40 65 140 140 :color (sdl:color :r 255 :g 255 :b 255))       ;;Chrackter Window
          (sdl:draw-rectangle-* 190 80 245 25 :color (sdl:color :r 128 :g 128 :b 128))       ;;Armor Bar
          (sdl:draw-rectangle-* 445 80 245 25 :color (sdl:color :r 230 :g 130 :b 238))       ;;Magic Shield Bar
          (sdl:draw-rectangle-* 190 120 500 25 :color (sdl:color :r 255 :g 000 :b 000))      ;;Health Bar
          (sdl:draw-rectangle-* 190 160 500 25 :color (sdl:color :r 000 :g 000 :b 255))      ;;Mana Bar
          (sdl:draw-rectangle-* 10 260 980 600 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 10 860 980 210 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 990 10 980 850 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 1020 40 920 100 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 990 860 980 210 :color (sdl:color :r 255 :g 255 :b 255))
          (sdl:draw-rectangle-* 1002 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 1
          (sdl:draw-rectangle-* 1242 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 2
          (sdl:draw-rectangle-* 1482 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 3
          (sdl:draw-rectangle-* 1722 870 235 190 :color (sdl:color :r 255 :g 255 :b 255))    ;;Skill 4
          (rect-array 350 320 6 5 90 10)                                                     ;;Inventar
          (rect-array 80 420 2 4 90 10)                                                      ;;Equipment
          (rect-array 45 320 4 1 50 20)

         (sdl:update-display))))))

(defun rect-array (x y i-width i-height i-size i-distance)
    (loop for inventar-width from 0 to (- i-width 1) do
      (loop for inventar-height from 0 to (- i-height 1) do
        (sdl:draw-rectangle-* 
         (+ x (* inventar-width (+ i-size i-distance))) ; x-coordinate
         (+ y (* inventar-height (+ i-size i-distance))) ; y-coordinate
         i-size ; icon width
         i-size ; icon height
         :color (sdl:color :r 255 :g 255 :b 255)))))


(static-hud)