extends CharacterBody2D

@export var acceleration = 650
@export var friction = 0.03
@export var max_speed = 6000

func _physics_process(delta: float):
    if Input.is_action_pressed("move_left"):
        velocity.x -= acceleration * delta
    if Input.is_action_pressed("move_right"):
        velocity.x += acceleration * delta
    if Input.is_action_pressed("move_up"):
        velocity.y -= acceleration * delta
    if Input.is_action_pressed("move_down"):
        velocity.y += acceleration * delta
    
    # clamp velocity
    if velocity.length() > max_speed:
        velocity = velocity.normalized() * max_speed
    move_and_slide()
    
    velocity -= velocity * friction * delta
    if velocity.length() < 1:
        velocity = Vector2()

func _input(event: InputEvent):
    pass
        
