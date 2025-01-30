(defstruct action-struct
  name         ;; Name der Aktion (z. B. "Fireball")
  short-info   ;; Kurze Beschreibung (z. B. "Deals fire damage to all enemies")
  action       ;; Die auszuführende Funktion
)

(defun apply-damage (entity damage )
  (let ((current-hp (stats-current-hp (entity-stats entity))))
    (setf (stats-current-hp (entity-stats entity))
          (max 0 (- current-hp damage))) 
    (format t "~A nimmt ~A Schaden!~%" (entity-name entity) damage)e
    (if (<= (stats-current-hp (entity-stats entity)) 0)
        (progn
          (format t "~A wurde besiegt!~%" (entity-name entity))
          (set-entity-animation entity :death ))
        (progn
          (format t "~A wurde getroffen!~%" (entity-name entity))
          (set-entity-animation entity :hit )))))



(defun apply-heal (entity heal)
  (let* ((stats (entity-stats entity))
         (current-hp (stats-current-hp stats))
         (max-hp (stats-max-hp stats))
         (new-hp (min (+ current-hp heal) max-hp))) ;; Sicherstellen, dass HP nicht über max-hp steigt
    (setf (stats-current-hp stats) new-hp)
    (format t "~A wird um ~A geheilt! Aktuelle HP: ~A/~A~%" 
            (entity-name entity) heal new-hp max-hp)))



(defparameter *actions*
  (list
   (make-action-struct
    :name "Fireball"
    :short-info "Deals fire damage to all enemies."
    :action (lambda (entity target)
              (format t "~A wirft einen Fireball auf ~A!~%"
                      (entity-name entity)
                      (entity-name target))))
   
   (make-action-struct
    :name "Heal"
    :short-info "Heals an ally."
    :action (lambda (entity target)
                (let ((heal 50))
                (format t "~A heilt ~A!~%"
                      (entity-name entity)
                      (entity-name entity))
                (apply-heal entity heal)))
   )
   
   (make-action-struct
    :name "Slash"
    :short-info "Performs a powerful melee attack."
    :action (lambda (entity target )
                (let ((damage 50)) ;; Test Damage
                (format t "~A greift ~A mit einem Slash an!~%"
                      (entity-name entity)
                      (entity-name target))
                (apply-damage target damage )))))

)




