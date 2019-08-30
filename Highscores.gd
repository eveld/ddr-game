extends Control

func _input(event):
	if event.is_action_pressed("e"):
		print("nothing")
		
	if event.is_action_pressed("q"):
		get_tree().change_scene("res://MainMenu.tscn")