extends Control

func _on_play_again_pressed():
    get_tree().change_scene_to_file("res://World/World.tscn")

func _on_main_menu_pressed():
    get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
