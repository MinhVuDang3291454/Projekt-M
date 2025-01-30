

(defun copy-stats (stats)
  "Erstellt eine Kopie einer `stats`-Struktur."
  (make-stats
   :strength (stats-strength stats)
   :dexterity (stats-dexterity stats)
   :intelligence (stats-intelligence stats)
   :vitality (stats-vitality stats)
   :max-hp (stats-max-hp stats)
   :current-hp (stats-current-hp stats)
   :max-ressource (stats-max-ressource stats)
   :current-ressource (stats-current-ressource stats)
   :max-physical-attack (stats-max-physical-attack stats)
   :current-physical-attack (stats-current-physical-attack stats)
   :max-magical-attack (stats-max-magical-attack stats)
   :current-magical-attack (stats-current-magical-attack stats)
   :max-physical-defense (stats-max-physical-defense stats)
   :current-physical-defense (stats-current-physical-defense stats)
   :max-magical-defense (stats-max-magical-defense stats)
   :current-magical-defense (stats-current-magical-defense stats)
   :max-armor (stats-max-armor stats)
   :current-armor (stats-current-armor stats)
   :max-magical-shield (stats-max-magical-shield stats)
   :current-magical-shield (stats-current-magical-shield stats)))


(defun update-entity-stats (entity)
  "Aktualisiert die Werte einer `entity` basierend auf ihrer Ausrüstung, Buffs und Debuffs."
  ;; 1. Kopiere die bestehenden Stats der Entity
  (let ((base-stats (copy-stats (entity-stats entity)))) ;; Kopiere bestehende Stats

    ;; 2. Werte aus der Ausrüstung hinzufügen
    (dolist (item (entity-equipment entity))
      (when item
        (let ((item-stats (item-stats item)))
          ;; Attribute
          (incf (stats-strength base-stats) (stats-strength item-stats))
          (incf (stats-dexterity base-stats) (stats-dexterity item-stats))
          (incf (stats-intelligence base-stats) (stats-intelligence item-stats))
          (incf (stats-vitality base-stats) (stats-vitality item-stats))
          ;; Angriffswerte
          (incf (stats-max-physical-attack base-stats) (stats-max-physical-attack item-stats))
          (incf (stats-max-magical-attack base-stats) (stats-max-magical-attack item-stats))
          ;; Verteidigungswerte
          (incf (stats-max-physical-defense base-stats) (stats-max-physical-defense item-stats))
          (incf (stats-max-magical-defense base-stats) (stats-max-magical-defense item-stats))
          (incf (stats-max-armor base-stats) (stats-max-armor item-stats))
          (incf (stats-max-magical-shield base-stats) (stats-max-magical-shield item-stats)))))

    ;; 3. Buffs und Debuffs anwenden
    (dolist (buff (entity-status entity))
      (let ((buff-stats (getf buff :stats)))
        (when buff-stats
          (incf (stats-strength base-stats) (stats-strength buff-stats))
          (incf (stats-vitality base-stats) (stats-vitality buff-stats)))))

    ;; 4. Aktualisierte Werte speichern
    (setf (entity-stats entity) base-stats)))




(defun print-entity-stats (entity)
  "Gibt die Statistiken einer `entity` im Konsolenformat aus."
  (let ((stats (entity-stats entity)))
    (format t "~%===== Statistiken von ~A =====~%" (entity-name entity))
    (format t "~%--- Attribute ---~%")
    (format t "Stärke: ~a~%" (stats-strength stats))
    (format t "Geschicklichkeit: ~a~%" (stats-dexterity stats))
    (format t "Intelligenz: ~a~%" (stats-intelligence stats))
    (format t "Vitalität: ~a~%" (stats-vitality stats))
    (format t "~%--- Lebens- und Ressourcenwerte ---~%")
    (format t "Maximale HP: ~a~%" (stats-max-hp stats))
    (format t "Aktuelle HP: ~a~%" (stats-current-hp stats))
    (format t "Maximale Ressource: ~a~%" (stats-max-ressource stats))
    (format t "Aktuelle Ressource: ~a~%" (stats-current-ressource stats))
    (format t "~%--- Angriffswerte ---~%")
    (format t "Maximaler physischer Angriff: ~a~%" (stats-max-physical-attack stats))
    (format t "Aktueller physischer Angriff: ~a~%" (stats-current-physical-attack stats))
    (format t "Maximaler magischer Angriff: ~a~%" (stats-max-magical-attack stats))
    (format t "Aktueller magischer Angriff: ~a~%" (stats-current-magical-attack stats))
    (format t "~%--- Verteidigungswerte ---~%")
    (format t "Maximale physische Verteidigung: ~a~%" (stats-max-physical-defense stats))
    (format t "Aktuelle physische Verteidigung: ~a~%" (stats-current-physical-defense stats))
    (format t "Maximale magische Verteidigung: ~a~%" (stats-max-magical-defense stats))
    (format t "Aktuelle magische Verteidigung: ~a~%" (stats-current-magical-defense stats))
    (format t "Maximale Rüstung: ~a~%" (stats-max-armor stats))
    (format t "Aktuelle Rüstung: ~a~%" (stats-current-armor stats))
    (format t "Maximales magisches Schild: ~a~%" (stats-max-magical-shield stats))
    (format t "Aktuelles magisches Schild: ~a~%" (stats-current-magical-shield stats))
    (format t "~%==============================~%")))


(defun make-entity-hero()
  "Erstellt eine Helden-Entity mit Standardwerten und verknüpft Buttons mit Fähigkeiten."
    (make-entity
     :name "Dummy"
     :entity-type :hero
     :stats (make-stats
             :strength 1
             :dexterity 1
             :intelligence 1
             :vitality 1
             :max-hp 150
             :current-hp 0
             :max-ressource 150
             :current-ressource 0)
     :abilities nil
     :equipment nil
     :x 100 ;; Startposition des Helden
     :y 200
     :buttons nil))


(defun switch-hero (game-state new-hero)
  "Wechselt den Helden im `game-state` und aktualisiert die Buttons entsprechend."
  (let ((abilities (entity-abilities new-hero))
        ;; Entferne die bestehenden Skill-Buttons
        (base-buttons (remove-if #'(lambda (btn)
                                     ;; Entferne Buttons, die sich auf Fähigkeiten beziehen
                                     (and (>= (button-x btn) 1002)
                                          (<= (button-x btn) 1722)))
                                 (game-state-buttons game-state))))
    ;; Erzeuge neue Skill-Buttons basierend auf den Fähigkeiten des neuen Helden
    (let ((new-skill-buttons (generate-skill-buttons abilities game-state)))
      ;; Aktualisiere den Helden und Buttons im game-state
      (setf (game-state-hero game-state) new-hero)
      (setf (game-state-buttons game-state)
            (append base-buttons new-skill-buttons)))))

(defun is-current-target-enemy (target)
  "Überprüft, ob das aktuelle Ziel ein Gegner ist."
  (and target (eq (entity-type target) :enemy)))

(defun get-current-target (game-state)
  "Gibt das aktuell ausgewählte Ziel im Spielstatus zurück."
  (game-state-current-target game-state))

(defun generate-skill-buttons (abilities game-state)
  "Erzeugt eine Liste von Buttons, die mit den Fähigkeiten verknüpft sind."
  (let ((button-x-start 1002) ;; Startposition für den ersten Button
        (button-y 870)       ;; Y-Position für alle Buttons
        (button-width 235)
        (button-height 190)
        (button-spacing 240)) ;; Abstand zwischen den Buttons
    (let ((buttons
           (loop for ability in abilities
                 for index from 0
                 collect (let ((current-ability ability))
                           (generate-button
                            (+ button-x-start (* index button-spacing))
                            button-y
                            button-width
                            button-height
                            (lambda ()
                              (let ((target (get-current-target game-state)))
                                (if target
                                    (progn
                                      ;; Aktion ausführen
                                      (funcall (action-struct-action current-ability)
                                               (game-state-hero game-state)
                                               target)
                                      ;; Setze das current-action-Flag
                                      (setf (game-state-current-action game-state) t))
                                    (format t "Kein Ziel ausgewählt!")))))))))
      buttons)))




(defun make-entity-hero-warrior (game-state)
  "Erstellt eine Helden-Entity mit Standardwerten für einen Krieger."
  (let* ((abilities (list
                     (find "Slash" *actions* :key #'action-struct-name :test #'string=)
                     (find "Shield Block" *actions* :key #'action-struct-name :test #'string=)))
         (buttons (generate-skill-buttons abilities game-state)))
    (make-entity
     :name "Conan the Warrior"
     :entity-type :hero
     :stats (make-stats
             :strength 15
             :dexterity 10
             :intelligence 5
             :vitality 20
             :max-hp 200
             :current-hp 200
             :max-ressource 100
             :current-ressource 100)
     :abilities abilities
     :equipment nil
     :x 100 ;; Startposition des Helden
     :y 200
     :buttons buttons)))


(defun make-entity-hero-mage (game-state)
  "Erstellt eine Helden-Entity mit Fähigkeiten und verknüpften Buttons."
  (let* ((abilities (list
                     (find "Fireball" *actions* :key #'action-struct-name :test #'string=)
                     (find "Heal" *actions* :key #'action-struct-name :test #'string=)
                     (find "Slash" *actions* :key #'action-struct-name :test #'string=)
                     ))
         ;; Erstelle die Buttons nur einmal
         (buttons (generate-skill-buttons abilities game-state)))
    (make-entity
     :name "Harry Potter"
     :entity-type :hero
     :stats (make-stats
             :strength 10
             :dexterity 8
             :intelligence 15
             :vitality 10
             :max-hp 150
             :current-hp 1
             :max-ressource 120
             :current-ressource 120
             :speed 10)
     :abilities abilities
     :equipment nil
     :x 100
     :y 200
     :buttons buttons)))
