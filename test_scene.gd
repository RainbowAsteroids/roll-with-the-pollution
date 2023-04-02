extends Node2D

func add_poison_drop(pd: Node):
    if pd:
        $CanvasGroup.add_child(pd)
