(defun reset-game ()
  "Setzt den Spielzustand zurück und initialisiert einen neuen Game-State."
  (setf *game-state*
        (make-game-state
         :hero (make-entity-hero) ;; Standard-Helden-Entity erstellen
         :items nil
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
         :enemies nil
         :enemy-spots (generate-all-enemy-spots)
         :current-target nil
         :buttons (list
                   (generate-button 700 100 90 90
                                    (lambda ()
                                      (print-entity-stats (game-state-hero *game-state*)))))
         :current-turn-entity nil
         :current-action nil
         :frame-timer 0
         :turn-queue nil
         :round-number 0))

  (switch-hero *game-state* (make-entity-hero-mage *game-state*))
)

(defun use-ability (game-state entity )
  "Lässt den Gegner eine zufällige Fähigkeit gegen den Helden einsetzen."
  (let ((abilities (entity-abilities entity)))
    (when abilities
      ;; Wähle eine zufällige Fähigkeit
      (let ((random-ability (nth (random (length abilities)) abilities)))
        (format t "~A setzt ~A ein!~%" (entity-name entity) (action-struct-name random-ability))

        ;; Ziel speichern und temporär auf den Helden setzen
        (let ((old-target (game-state-current-target game-state)))
          (setf (game-state-current-target game-state) (game-state-hero game-state))

          ;; Fähigkeit ausführen
          (funcall (action-struct-action random-ability) entity (game-state-hero game-state))

          ;; Ziel zurücksetzen
          (setf (game-state-current-target game-state) old-target)

          ;; Setze das current-action-Flag und einen Timer für die Animation
          (setf (game-state-current-action game-state) t)
          (set-entity-animation entity :attack)))))) ;;Attack Animation starten


(defun determine-turn-order (game-state)
  "Bestimmt die Zugreihenfolge für die aktuelle Runde."
  (let ((entities (append (list (game-state-hero game-state))
                          (game-state-enemies game-state))))
    ;; Sortiere nach Geschwindigkeit oder einer anderen Logik
    (setf (game-state-turn-queue game-state)
          (sort entities #'> :key (lambda (e) (stats-speed (entity-stats e)))))
    (format t "Zugreihenfolge gesetzt: ~A~%" 
            (mapcar #'entity-name (game-state-turn-queue game-state)))))


(defun check-combat (game-state)
  "Überprüft den Kampfstatus und führt Aktionen aus."
  (cond
    ;; Falls die Turn-Queue leer ist, starte eine neue Runde
    ((null (game-state-turn-queue game-state))
     (incf (game-state-round-number game-state))
     (determine-turn-order game-state)
     (format t "==== Neue Runde: ~A ====~%" (game-state-round-number game-state)))

    ;; Falls eine Aktion läuft, warte, bis die Animation fertig ist
    ((and (game-state-current-action game-state)
          (> (game-state-frame-timer game-state)))
     (decf (game-state-frame-timer game-state)))

    ;; Falls keine Aktion läuft, ziehe die nächste Einheit
    (t
     (let ((next-entity (pop (game-state-turn-queue game-state))))
       (when next-entity
         (setf (game-state-current-turn-entity game-state) next-entity)

         ;; Falls der Gegner an der Reihe ist
         (if (eq (entity-entity-type next-entity) :enemy)
             (use-ability game-state next-entity)
             ;; Falls der Spieler an der Reihe ist, warte auf eine Aktion
             (setf (game-state-current-action game-state) nil)))))))
