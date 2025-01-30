(defparameter *enemy-animations* (make-hash-table :test 'equal)
  "Speichert die Animationen für alle Gegnertypen.")


(defun render-entity (entity )
  (let* ((animations (gethash (entity-name entity) *enemy-animations*)))
    (unless animations
      (error "Keine Animationen für Entity: ~A" (entity-name entity)))
    (let* ((current-animation (gethash (entity-animation-type entity) animations))
           (frames (getf current-animation :frames))
           (frame-count (getf current-animation :frame-count))
           (current-frame (or (entity-current-frame entity) 0)) 
           (frame (nth current-frame frames))
           (x (entity-x entity))
           (y (entity-y entity)))
      (sdl:draw-surface-at-* frame x y)
      (incf (entity-frame-counter entity))
      (when (>= (entity-frame-counter entity) (entity-frame-delay entity))
        (setf (entity-frame-counter entity) 0) 

        ;; Zurücksetzen auf Idle
        (if (>= (1+ current-frame) frame-count)
            (set-entity-animation entity :idle) ;
            (setf (entity-current-frame entity) (mod (1+ current-frame) frame-count)))))))




(defun set-entity-animation (entity animation-type )
  (let* ((animations (gethash (entity-name entity) *enemy-animations*))
         (animation (gethash animation-type animations)))
    (unless animation
      (error "Animation ~A für Entität ~A nicht gefunden." animation-type (entity-name entity)))
    (setf (entity-animation-type entity) animation-type)
    (setf (entity-sprite-frames entity) (getf animation :frames))
    (setf (entity-current-frame entity) 0)  
    (setf (entity-frame-counter entity) 0)
    (setf (entity-frame-delay entity) 0) 

    ;; Setze den frame-timer auf die Dauer der Animation
    (setf (game-state-frame-timer *game-state*) (getf animation :frame-count))))



(defun render-enemies (game-state)
  (let ((enemies (game-state-enemies game-state)))
    (setf (game-state-enemies game-state)
          (remove-if (lambda (enemy)
                       (and (eq (entity-animation-type enemy) :death)
                            (= (entity-current-frame enemy)
                               (1- (length (entity-sprite-frames enemy))))))
                     enemies))
    (dolist (enemy enemies)
      (when (eq (entity-entity-type enemy) :enemy)
        (render-entity enemy )))))
