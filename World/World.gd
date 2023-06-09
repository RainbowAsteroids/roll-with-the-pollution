extends Node2D

@export var arrow_scene: PackedScene

var collectable_pairs: Array[CollectablePairing] = []
@onready var camera: Camera2D = $Player/Camera2D
@onready var start_time := Time.get_ticks_msec() as float

class CollectablePairing:
    var arrow: Sprite2D
    var collectable: Collectable
    
    func _init(collectable: Collectable, arrow: Sprite2D):
        self.arrow = arrow
        self.collectable = collectable

func _ready():
    var map: MapGenerator = $PatternContainer
    var section := map.sections[0]
    var center := section.bounds.position + (section.bounds.size / 2)
    var pos := map.map_to_local(center)
    $Player.position = pos

func add_poison_drop(pd: Node):
    if pd:
        $CanvasGroup.add_child(pd)

func _physics_process(delta: float):
    for pair in collectable_pairs:
        var collectable = pair.collectable
        var arrow = pair.arrow
        var c_pos = collectable.global_position
        arrow.position = $Player.position + ($Player.velocity * delta)
        arrow.look_at(c_pos)
        arrow.visible = true

func _on_pattern_container_added_collectable(collectable: Collectable):
    var arrow = arrow_scene.instantiate()
    arrow.visible = false
    add_child.call_deferred(arrow) # this function is called during $PatternContainer's _ready
    collectable_pairs.append(CollectablePairing.new(collectable, arrow))

func _on_player_collectable_collected(collectable):
    var pairing = collectable_pairs \
        .filter(func(pair): return pair.collectable == collectable)[0]
    var index = collectable_pairs.find(pairing)
    collectable_pairs.pop_at(index)
    pairing.collectable.queue_free()
    pairing.arrow.queue_free()
    

func _on_player_dead():
    get_tree().change_scene_to_file("res://UI/DeathScreen.tscn")

func _on_player_win():
    var end_time = Time.get_ticks_msec() as float
    RunTimeManager.last_time = (end_time - start_time) / 1000
    get_tree().change_scene_to_file("res://UI/VictoryScreen.tscn")
