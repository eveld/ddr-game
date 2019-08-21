extends Control

func _on_Play_pressed():
	get_tree().change_scene("res://GameMenu.tscn")

func _on_Option_pressed():
	get_tree().change_scene("res://OptionMenu.tscn")