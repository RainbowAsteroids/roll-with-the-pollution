extends Control

func _ready():
    # Hide quit button on mobile
    if OS.get_name() == "Web":
        $VBoxContainer/QuitGame.visible = false

func _on_play_game_pressed():
    get_tree().change_scene_to_file("res://World/World.tscn")

func _on_quit_game_pressed():
    get_tree().quit()
