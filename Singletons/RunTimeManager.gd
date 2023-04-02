extends Node

const best_time_file_path := "user://best-time.dat"
var best_time_file: FileAccess

var _last_time := 0.0
var last_time: float:
    get: return _last_time
    set(v):
        _last_time = v
        best_time = v

var _best_time := 0.0
var best_time: float:
    get: return _best_time
    set(v):
        if _best_time > v or _best_time == 0.0:
            _best_time = v
            
            best_time_file.seek(0)
            best_time_file.store_float(v)
            best_time_file.flush()

func _ready():
    if FileAccess.file_exists(best_time_file_path):
        var file := FileAccess.open(best_time_file_path, FileAccess.READ)
        
        var _best_time = file.get_float()
        
        file.close()
    best_time_file = FileAccess.open(best_time_file_path, FileAccess.WRITE)
    if best_time != 0.0:
        best_time_file.seek(0)
        best_time_file.store_float(best_time)
        best_time_file.flush()

func format_number(n: int, size: int) -> String:
    var result := str(n)
    
    while (result.length() < size):
        result = "0" + result
    
    return result

func format_time(time: float) -> String:
    # MM:SS:MS
    var minutes := (time / 60) as int
    var seconds := (time as int) % 60
    var millis := ((time - floor(time)) * 1000) as int
    
    return "{m}:{s}:{ms}".format({
        "m": format_number(minutes, 2), 
        "s": format_number(seconds, 2), 
        "ms": format_number(millis, 3)
    })
