(defparameter *item-templates* 
  (list
   (make-item :name "Warrior's Helmet" 
              :id 1 
              :item-type "HELM" 
              :stats (make-stats :max-physical-defense 50 :strength 10)
              :rarity "Rare" 
              :level-requierment 1 
              :value 100 
              :special-abilities "Increases physical resistance by 10%"
              :icon-path "Item-Icons/armor/headgear/helmet_2_etched.png")
              
   (make-item :name "Steel Chestplate" 
              :id 2 
              :item-type "CHEST" 
              :stats (make-stats :max-physical-defense 100 :vitality 15)
              :rarity "Epic" 
              :level-requierment 1 
              :value 250 
              :special-abilities "Reduces incoming physical damage by 5%"
              :icon-path "Item-Icons/armor/torso/plate_mail_2.png")
              
   (make-item :name "Warrior's Gloves" 
              :id 3 
              :item-type "HANDS" 
              :stats (make-stats :max-physical-defense 40 :strength 5 :vitality 10)
              :rarity "Common" 
              :level-requierment 3 
              :value 50
              :icon-path "Item-Icons/armor/hands/glove_4_new.png")
              
   (make-item :name "Steel Boots" 
              :id 4 
              :item-type "BOOTS" 
              :stats (make-stats :max-physical-defense 30 :dexterity 5)
              :rarity "Rare" 
              :level-requierment 4 
              :value 75
              :icon-path "Item-Icons/armor/feet/boots_iron_2.png")
              
   (make-item :name "Wizard's Hat" 
              :id 5 
              :item-type "HELM" 
              :stats (make-stats :max-magical-defense 20 :intelligence 15)
              :rarity "Rare" 
              :level-requierment 1 
              :value 120 
              :special-abilities "Increases magic resistance by 10%"
              :icon-path "Item-Icons/armor/headgear/wizard_hat_1.png")
              
   (make-item :name "Enchanted Robe" 
              :id 6 
              :item-type "CHEST" 
              :stats (make-stats :max-magical-defense 40 :intelligence 20 :vitality 10)
              :rarity "Epic" 
              :level-requierment 1 
              :value 300 
              :special-abilities "Reduces mana cost by 10%"
              :icon-path "Item-Icons/armor/torso/robe_1_new.png")
              
   (make-item :name "Sorcerer's Gloves" 
              :id 7 
              :item-type "HANDS" 
              :stats (make-stats :max-magical-defense 30 :intelligence 10)
              :rarity "Common" 
              :level-requierment 3 
              :value 60
              :icon-path "Item-Icons/armor/hands/glove_4_old.png")
              
   (make-item :name "Mystic Boots" 
              :id 8 
              :item-type "BOOTS" 
              :stats (make-stats :max-magical-defense 25 :dexterity 5)
              :rarity "Rare" 
              :level-requierment 4 
              :value 80 
              :special-abilities "Increases movement speed by 5%"
              :icon-path "Item-Icons/armor/feet/boots_1_brown_old.png")))
