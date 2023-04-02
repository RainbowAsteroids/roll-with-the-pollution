extends Label

func _ready():
    text = "Best time: %s" % RunTimeManager.format_time(RunTimeManager.best_time)
