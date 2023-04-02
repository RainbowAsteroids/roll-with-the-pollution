extends CharacterBody2D
class_name Player

signal dead

@export var acceleration := 650.0
@export var friction := 0.03
@export var max_speed := 6000.0
@export var braking_force := 2.5
@export var poison_drop: PackedScene

var _health := GlobalConstants.max_health
@export var health: float:
    get: return _health
    set(v):
        _health = v
        $CanvasLayer/HealthBar.health = v
        if v < 0: 
            dead.emit()

func _draw():
    draw_circle(Vector2(), 36, Color.BLUE_VIOLET)

func _physics_process(delta: float):
    var motion := Vector2()
    if Input.is_action_pressed("move_left"):
        motion.x -= 1
    if Input.is_action_pressed("move_right"):
        motion.x += 1
    if Input.is_action_pressed("move_up"):
        motion.y -= 1
    if Input.is_action_pressed("move_down"):
        motion.y += 1
    
    motion = motion.normalized()
    var dot := -(velocity.normalized().dot(motion))
    if dot > 0:
        motion *= (dot * braking_force) + 1
    velocity += motion * acceleration * delta
    # clamp velocity
    if velocity.length() > max_speed:
        velocity = velocity.normalized() * max_speed
    move_and_slide()
    
    velocity -= velocity * friction * delta
    if velocity.length() < 1:
        velocity = Vector2()

func _on_poison_timer_timeout():
    var pd = poison_drop.instantiate()
    pd.position = position
    get_parent().add_poison_drop(pd)
