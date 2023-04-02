extends CanvasItem

var thickness := 50
var width := 1920

var _background_color := Color()
@export var background_color: Color:
    get: return _background_color
    set(v): 
        _background_color = v
        queue_redraw()
            
var _foreground_color := Color()
@export var foreground_color: Color:
    get: return _foreground_color
    set(v): 
        _foreground_color = v
        queue_redraw()

var _health := GlobalConstants.max_health

var health: float:
    get: return _health
    set(v): 
        _health = v
        queue_redraw()

func _draw():
    draw_line(Vector2(), Vector2(width, 0), background_color, thickness)
    draw_line(Vector2(), Vector2(width * (health / GlobalConstants.max_health), 0), foreground_color, thickness)
