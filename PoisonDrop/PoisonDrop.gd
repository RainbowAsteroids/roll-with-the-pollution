extends Area2D

var expand_rate := 100.0
var max_radius := 400.0
var initial_radius := 50.0

@onready var shape: CircleShape2D = $CollisionShape2D.shape
var _radius := initial_radius
var radius: float:
    get: return _radius
    set(v):
        _radius = v
        shape.radius = v
        queue_redraw()
        
func _ready():
    var images = [
        preload("res://PoisonDrop/Sprites/banana.png"),
        preload("res://PoisonDrop/Sprites/crumpled-bag.png"),
        preload("res://PoisonDrop/Sprites/sodacan.png"),
    ]
    var sprite = Sprite2D.new()
    sprite.texture = images.pick_random()
    sprite.z_index = 5
    add_child(sprite)

func _draw():
    draw_circle(Vector2(), radius, Color(.4,.4,.4))

func _process(delta: float):
    if radius < max_radius:
        radius = min(max_radius, shape.radius + (expand_rate * delta))
