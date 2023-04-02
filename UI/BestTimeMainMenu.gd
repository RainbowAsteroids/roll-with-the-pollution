extends Label

func _ready():
    if RunTimeManager.best_time != 0.0:
        text = "Best time: %s" % RunTimeManager.format_time(RunTimeManager.best_time)
        visible = true
