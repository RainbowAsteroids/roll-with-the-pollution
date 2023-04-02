extends Area2D
class_name Collectable

func _on_body_entered(player: Player):
    if player:
        player.collected_collectable()
        queue_free()
