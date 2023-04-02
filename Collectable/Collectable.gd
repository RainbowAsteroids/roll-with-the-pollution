extends Area2D
class_name Collectable

var collected = false

func _ready():
    var images := [
        preload("res://Collectable/Sprites/picture-day.png"),   
        preload("res://Collectable/Sprites/picture-night.png"),   
        preload("res://Collectable/Sprites/picture-evening.png"),   
    ]
    
    var sprite = Sprite2D.new()
    sprite.texture = images.pick_random()
    sprite.rotation_degrees = 360 * randf()
    add_child(sprite)

func _on_body_entered(player: Player):
    if not collected and player:
        player.collected_collectable(self)
        collected = true
        visible = false
