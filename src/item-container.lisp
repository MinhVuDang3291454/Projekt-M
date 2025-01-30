;;(ql:quickload :lispbuilder-sdl)

;;(load "drag-n-drop.lisp")

(defstruct item
  name       ;; Name 
  id         ;; ID 
  x          ;; X-Position
  y          ;; Y-Position
  (width 88)   ;; Breite
  (height 88))  ;; Höhe    

(defun show-item (item)
    (sdl:draw-rectangle-* (+ (item-x item) 1)  (+ (item-y item) 1)
                        (item-width item) (item-height item)
                        :color (sdl:color :r 138 :g 138 :b 138))
    (sdl:with-color (random-color (sdl:color :r 138 :g 138 :b 138))
            (sdl:flood-fill-* (+ (item-x item) 2) (+ (item-y item) 2) :surface sdl:*default-display*)))



(defun run-drag-and-drop (items)
  "Generische Funktion für Drag-and-Drop-Logik. Nimmt eine Liste von Items als Parameter."
  (sdl:with-init ()
    (sdl:window 800 600 :title-caption "Drag and Drop Test")
    (setf (sdl:frame-rate) 30)

    ;; Lokale Variablen für Drag-and-Drop
    (let ((dragging nil)
          (drag-offset-x 0)
          (drag-offset-y 0)
          (current-item nil)) ;; Das aktuell gezogene Item

      (sdl:with-events ()
        (:quit-event () t)

        ;; Dragging starten
        (:mouse-button-down-event (:x x :y y)
         (dolist (item items)
           (when (and (>= x (item-x item))
                      (< x (+ (item-x item) (item-width item)))
                      (>= y (item-y item))
                      (< y (+ (item-y item) (item-height item))))
             (setf dragging t)
             (setf current-item item)
             (setf drag-offset-x (- x (item-x item)))
             (setf drag-offset-y (- y (item-y item))))))

        ;; Dragging stoppen
        (:mouse-button-up-event ()
         (setf dragging nil)
         (setf current-item nil))

        ;; Item bewegen, während Dragging aktiv ist
        (:mouse-motion-event (:x x :y y)
         (when dragging
           (when current-item
             (setf (item-x current-item) (- x drag-offset-x))
             (setf (item-y current-item) (- y drag-offset-y)))))

        (:key-down-event (:key key)
         (when (eq key :sdl-key-escape)
           (sdl:push-quit-event)))

        (:idle ()
         ;; Hintergrund löschen
         (sdl:clear-display (sdl:color :r 0 :g 0 :b 0))

         ;; Items anzeigen
         (dolist (item items)
           (show-item item))

         ;; Display aktualisieren
         (sdl:update-display))))))







(defun test1 ()
"Testfunktion für Drag-and-Drop mit mehreren Items."
  (sdl:with-init ()
    (sdl:window 800 600 :title-caption "Drag and Drop Test")
    (setf (sdl:frame-rate) 30)

    ;; Container für Items (lokale Variable statt `defparameter`)
    (let ((items (list
                  (make-item :name "Schwert" :id 3 :x 400 :y 100)
                  (make-item :name "Schild" :id 4 :x 550 :y 100)
                  (make-item :name "Trank" :id 5 :x 700 :y 100))))))
    (run-drag-and-drop items))




(defun test ()
"Testfunktion für Drag-and-Drop mit mehreren Items."
  (sdl:with-init ()
    (sdl:window 800 600 :title-caption "Drag and Drop Test")
    (setf (sdl:frame-rate) 30)

    ;; Container für Items (lokale Variable statt `defparameter`)
    (let ((items (list
                  (make-item :name "Schwert" :id 3 :x 400 :y 100)
                  (make-item :name "Schild" :id 4 :x 550 :y 100)
                  (make-item :name "Trank" :id 5 :x 700 :y 100)))
          (dragging nil)
          (drag-offset-x 0)
          (drag-offset-y 0)
          (current-item nil)) ;; Das aktuell gezogene Item

      (sdl:with-events ()
        (:quit-event () t)

        ;; Dragging starten
        (:mouse-button-down-event (:x x :y y)
         (dolist (item items)
           (when (and (>= x (item-x item))
                      (< x (+ (item-x item) (item-width item)))
                      (>= y (item-y item))
                      (< y (+ (item-y item) (item-height item))))
             (setf dragging t)
             (setf current-item item)
             (setf drag-offset-x (- x (item-x item)))
             (setf drag-offset-y (- y (item-y item))))))

        ;; Dragging stoppen
        (:mouse-button-up-event ()
         (setf dragging nil)
         (setf current-item nil))

        ;; Item bewegen, während Dragging aktiv ist
        (:mouse-motion-event (:x x :y y)
         (when dragging
           (when current-item
             (setf (item-x current-item) (- x drag-offset-x))
             (setf (item-y current-item) (- y drag-offset-y)))))

        (:key-down-event (:key key)
         (when (eq key :sdl-key-escape)
           (sdl:push-quit-event)))

        (:idle ()
         ;; Hintergrund löschen
         (sdl:clear-display (sdl:color :r 0 :g 0 :b 0))

         ;; Items anzeigen
         (dolist (item items)
           (show-item item))

         ;; Display aktualisieren
         (sdl:update-display))))))

