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
        

func _draw():
    draw_circle(Vector2(), radius, Color(0,0,0))

func _process(delta: float):
    if radius < max_radius:
        radius = min(max_radius, shape.radius + (expand_rate * delta))
