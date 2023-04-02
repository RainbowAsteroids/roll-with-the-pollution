extends Area2D
class_name Collectable

var collected = false

func _on_body_entered(player: Player):
    if not collected and player:
        player.collected_collectable(self)
        collected = true
        visible = false
