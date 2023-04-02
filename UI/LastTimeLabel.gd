extends Label

func _ready():
    text = "Your time: %s" % RunTimeManager.format_time(RunTimeManager.last_time)
