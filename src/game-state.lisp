

(defstruct entity
  (name nil)        ;; Name der Entität (z. B. "Hero" oder "Skeleton")
  (entity-type nil)  ;; Typ der Entität: :hero, :enemy, :npc, etc.
  (stats nil)        ;; Gemeinsame Stats-Struktur (z. B. HP, Mana, etc.)
  (abilities nil)   ;; Liste von Aktionen oder Fähigkeiten
  (status nil)      ;; Liste von Status-Effekten (z. B. Buffs/Debuffs)
  (equipment nil)  ;; Liste oder andere Struktur für die Ausrüstung

  ;; Animationseigenschaften
  (sprite-frames nil)   ;; Liste der Animations-Frames
  (current-frame 0)   ;; Aktueller Frame-Index
  (frame-counter 0)   ;; Zähler für die Frame-Verzögerung
  (frame-delay 0)    ;; Anzahl der Zyklen zwischen Frames
  (animation-timer 0) ;; Timer
  (animation-type nil)  ;; Aktueller Animationstyp (z. B. :idle, :attack)
  
  ;; Position
  (x 0)           ;; X-Position der Entität
  (y 0)           ;; Y-Position der Entität

  (buttons nil)
)

(defstruct stats
  (strength 0)
  (dexterity 0)
  (intelligence 0)
  (vitality 0)
  (speed 0)
  (max-hp 0)
  (current-hp 0)
  (max-ressource 0)
  (current-ressource 0)
  (max-physical-attack 0)
  (current-physical-attack 0)
  (max-magical-attack 0)
  (current-magical-attack 0)
  (max-physical-defense 0)
  (current-physical-defense 0)
  (max-magical-defense 0)
  (current-magical-defense 0)
  (max-armor 0)
  (current-armor 0)
  (max-magical-shield 0)
  (current-magical-shield 0)
)

(defstruct game-state
  hero           ;; Referenz auf die `entity` des Helden
  enemies        ;; Liste von `entity`-Instanzen für die Gegner
  items          ;; Liste von Items im Inventar
  dragging       ;; 
  drag-offset-x  ;; X Offset beim Ziehen des Items
  drag-offset-y  ;; Y Offset beim Ziehen des Items
  current-item   ;; Akutelles ausgewhälte Item
  current-item-spot  ;; Aktuelle Inventarstelle wo das Item hingezogen wurde
  current-equipment-spot ;; Aktuelle Ausrüstungsstelle woe das Item hingezogen wurde
  current-item-type  ;; Akuteller Typ des Items
  current-shop-spot  ;; Aktueller Shopstelle 
  inventory-spots  
  equipment-spots
  shop-spots
  enemy-spots
  current-enemy-spot
  current-target
  buttons   ;; Buttons für Aktionen
  current-turn-entity     ;; Welche Entity ist aktuell dran?
  current-action          ;; Ist Nil und es wird solange auf den Zug gewartet bis eine Aktion ausgeführt wird
  frame-timer             ;; Frame Timer gesetzt bis die animation durchgelaufen ist
  turn-queue              ;; Reihenfolge der Aktionen
  round-number            ;; Aktuelle Runde
)       

(defstruct item
;; Rendering Informationen
    name        ;; Name 
    id          ;; ID 
    (x 0)          ;; X-Position
    (y 0)           ;; Y-Position
    (width 88)  ;; Breite
    (height 88) ;; Höhe  
    (old-x 0)       ;; ursprüngliche x-Koordinaten fürs zurücksnappen
    (old-y 0)      ;; ursprüngliche y-Koordianten fürs zurücksnappen  
    (icon-path nil)    ;; Icon-Path   
;; Base Werte
    
    (stats nil)          ;; Eine `stats`-Struktur für alle grundlegenden Werte

;; Erweiterte Werte
    item-type   ;; Helm, Chest, Hands, Boots, Amulet, Weapon, Offhand, Ring, Consumable
    (rarity "Common" )        ;; Common, Rare, Epic, Legendary
    (level-requierment 1) ;; Mindestlevel für den Shopgenerator
    (value 1)          ;; Goldwert
    (set-id 0)          ;; Set-Bonus
    (enchantments "None")    ;; Liste von Verzauberungen
    (status-effects "None")  ;; Status-Effekte beim Tragen
    (special-abilities "None") ;; Spezielle Fähigkeiten oder Effekte
    (stackable nil)      ;; Ist das Item stapelbar? (T/NIL)
    (stack-size 0)     ;; Maximale Anzahl pro Stapel
  )
 

(defstruct inventory-spot
    x
    y
    width
    height
    item) ;; Aktuelles Item im Inventory (oder NIL, wenn leer)

(defstruct equipment-spot
    x
    y
    width
    height
    item
    item-restriction 
)

(defstruct shop-spot
    x
    y
    width
    height
    item
)


;; nicht gebraucht alt
(defstruct enemy
  ;; Position und Bewegung
  x           ;; X-Koordinate des Gegners
  y           ;; Y-Koordinate des Gegners
  
  ;; Animation
  sprite-frames  ;; Liste der Frames für die Animation
  current-frame  ;; Aktueller Frame (Index in `sprite-frames`)
  frame-delay    ;; Anzahl der Idle-Zyklen zwischen Frame-Wechseln
  frame-counter  ;; Interner Zähler für die Frame-Verzögerung
  animation-type    ;; Aktueller Animationstyp (z. B. :idle, :attack, :hit, :death)
  animation-timer   ;; Timer für Sonderanimationen, zählt in Frames runter
  
  ;; Status und Eigenschaften
  (stats nil) 
  enemy-type  ;; Typ des Gegners 
  ability ;; Liste von Aktionen
)

(defstruct enemy-spot
    x
    y
    width
    height
    enemy
)

(defstruct button
    x
    y
    width
    height
    (pressed nil)
    (action nil)
)


(defun generate-inventory-spots (x y i-width i-height i-size i-distance)
  "Erzeugt eine Liste von Inventarspots basierend auf einem Raster."
  (let (spots)
    (loop for inventar-width from 0 to (- i-width 1) do
          (loop for inventar-height from 0 to (- i-height 1) do
            (push (make-inventory-spot
                   :x (truncate (+ x (* inventar-width (+ i-size i-distance)))) ;; Stelle sicher, dass :x ein FIXNUM ist
                   :y (truncate (+ y (* inventar-height (+ i-size i-distance)))) ;; Stelle sicher, dass :y ein FIXNUM ist
                   :width (truncate i-size) ;; Stelle sicher, dass :width ein FIXNUM ist
                   :height (truncate i-size) ;; Stelle sicher, dass :height ein FIXNUM ist
                   :item nil) ;; Spot ist leer
                  spots)))
    (nreverse spots))) ;; Um die Reihenfolge korrekt zu halten

    ;;(generate-inventory-spots 350 320 6 5 90 10)

(defun generate-equipment-spots (x y i-width i-height i-size i-distance)
  "Erzeugt eine Liste von Equipmentspots basierend auf einem Raster mit spezifischen Beschränkungen."
  (let* ((restrictions '("HELM" "CHEST" "HANDS" "BOOTS" "AMULET" "WEAPON" "OFFHAND" "RING")) ;; Reihenfolge der Slots
         (spots nil)
         (index 0)) ;; Um die Restriction-Liste zu durchlaufen
    (loop for equipment-width from 0 to (- i-width 1) do
          (loop for equipment-height from 0 to (- i-height 1) do
            (let ((restriction (nth index restrictions))) ;; Restriction aus der Liste holen
              (push (make-equipment-spot
                     :x (truncate (+ x (* equipment-width (+ i-size i-distance)))) ;; Stelle sicher, dass :x ein FIXNUM ist
                     :y (truncate (+ y (* equipment-height (+ i-size i-distance)))) ;; Stelle sicher, dass :y ein FIXNUM ist
                     :width (truncate i-size) ;; Stelle sicher, dass :width ein FIXNUM ist
                     :height (truncate i-size) ;; Stelle sicher, dass :height ein FIXNUM ist
                     :item nil
                     :item-restriction restriction) ;; Beschränkung setzen
                    spots)
              (setf index (1+ index))))) ;; Zum nächsten Restriction springen
    (nreverse spots))) ;; Um die Reihenfolge korrekt zu halten
    ;;(generate-equipment-spots 80 420 2 4 90 10)

(defun generate-shop-spots (x y i-width i-height i-size i-distance)
  "Erzeugt eine Liste von Shopspots basierend auf einem Raster."
  (let (spots)
    (loop for shop-width from 0 to (- i-width 1) do
          (loop for shop-height from 0 to (- i-height 1) do
            (push (make-shop-spot
                   :x (truncate (+ x (* shop-width (+ i-size i-distance)))) ;; Stelle sicher, dass :x ein FIXNUM ist
                   :y (truncate (+ y (* shop-height (+ i-size i-distance)))) ;; Stelle sicher, dass :y ein FIXNUM ist
                   :width (truncate i-size) ;; Stelle sicher, dass :width ein FIXNUM ist
                   :height (truncate i-size) ;; Stelle sicher, dass :height ein FIXNUM ist
                   :item nil) ;; Spot ist leer
                  spots)))
    (nreverse spots))) ;; Um die Reihenfolge korrekt zu halten
    ;;(generate-shop-spots 80 920 5 1 90 30)


(defun generate-enemy-spots (x y i-width i-height i-size i-distance)
  "Erzeugt eine Liste von Enemyspots basierend auf einem Raster."
  (let (spots)
    (loop for enemy-width from 0 to (- i-width 1) do
          (loop for enemy-height from 0 to (- i-height 1) do
            (push (make-enemy-spot
                   :x (truncate (+ x (* enemy-width (+ i-size i-distance)))) ;; Stelle sicher, dass :x ein FIXNUM ist
                   :y (truncate (+ y (* enemy-height (+ i-size i-distance)))) ;; Stelle sicher, dass :y ein FIXNUM ist
                   :width (truncate i-size) ;; Stelle sicher, dass :width ein FIXNUM ist
                   :height (truncate i-size) ;; Stelle sicher, dass :height ein FIXNUM ist
                   :enemy nil) ;; Spot ist leer

                  spots)))
    (nreverse spots))) ;; Um die Reihenfolge korrekt zu halten
    ;;(generate-enemy-spots 1100 300 3 1 256 44)
    ;;(generate-enemy-spots 1250 600 2 1 256 44)

(defun generate-all-enemy-spots ()
  (append (generate-enemy-spots 1100 250 5 1 128 22)
          (generate-enemy-spots 1100 500 5 1 128 22)))


(defun fill-enemy-spots (game-state)
  "Verknüpft die `enemy-spots` in `game-state` mit den passenden `enemies` basierend auf deren Koordinaten."
  (let ((enemies (game-state-enemies game-state))
        (enemy-spots (game-state-enemy-spots game-state)))
    (dolist (enemy enemies)
      (let ((x (entity-x enemy))
            (y (entity-y enemy)))
        ;; Finde den passenden Spot basierend auf den Koordinaten
        (dolist (spot enemy-spots)
          (when (and (= x (enemy-spot-x spot))
                     (= y (enemy-spot-y spot)))
            ;; Verknüpfe den Gegner mit dem Spot
            (setf (enemy-spot-enemy spot) enemy)))))))


(defun generate-button (x y width height &optional (action nil))
    "Erzeugt einen neuen Button."
  (make-button :x x :y y :width width :height height :pressed nil :action action) 
)