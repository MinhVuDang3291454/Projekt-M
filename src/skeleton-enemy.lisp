

(defun initialize-skeleton-animations ()
  "Lädt die Animations-Frames für alle Gegnertypen."
  (unless (gethash "Skeleton" *enemy-animations*)
    ;; Skeleton-Animationen
    (let ((skeleton-animations (make-hash-table :test 'equal)))
      ;; Idle Animation
      (setf (gethash :idle skeleton-animations)
            (list
             :frames (list
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_idle-0-0.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_idle-1-0.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_idle-2-0.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_idle-3-0.png"))
             :frame-count 4))
      ;; Attack Animation
      (setf (gethash :attack skeleton-animations)
            (list
             :frames (list
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-00-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-01-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-02-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-03-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-04-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-05-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-06-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-07-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-08-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-09-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-10-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-11-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_attack-12-00.png")
                    )
             :frame-count 13))
      ;; Hit Animation
      (setf (gethash :hit skeleton-animations)
            (list
             :frames (list
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_hit-00-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_hit-01-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_hit-02-00.png")
                      )
             :frame-count 3))
      ;; Death Animation
      (setf (gethash :death skeleton-animations)
            (list
             :frames (list
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-00-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-01-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-02-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-03-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-04-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-05-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-06-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-07-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-08-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-09-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-10-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-11-00.png")
                      (sdl:load-image "Enemies/Skeleton/Skeleton_enemy_death-12-00.png")
                      )
             :frame-count 13))
      ;; Skeleton-Animationen in die globale Tabelle speichern
      (setf (gethash "Skeleton" *enemy-animations*) skeleton-animations))))



