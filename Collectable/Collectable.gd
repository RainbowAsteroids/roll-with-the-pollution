extends Area2D
class_name Collectable

const initial_alpha := 0.5

var collected := false
var alpha := initial_alpha

func _draw():
    draw_circle(Vector2(), 38, Color(0.9,0.9,0.1,alpha))

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
    
    var tween = create_tween()
    tween.tween_property(self, "alpha", 1, 1)
    tween.tween_property(self, "alpha", initial_alpha, 1)
    tween.set_loops()

func _on_body_entered(player: Player):
    if not collected and player:
        player.collected_collectable(self)
        collected = true
        visible = false

func _process(delta):
    queue_redraw()
