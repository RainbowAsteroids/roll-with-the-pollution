extends Node2D

func _ready():
    var map: MapGenerator = $PatternContainer
    var section := map.sections[0]
    var center := section.bounds.position + (section.bounds.size / 2)
    var pos := map.map_to_local(center)
    $Player.position = pos

func add_poison_drop(pd: Node):
    if pd:
        $CanvasGroup.add_child(pd)
