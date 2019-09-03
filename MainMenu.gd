extends Control

func _input(event):
	if event.is_action_pressed("e"):
		start_game()
		
	if event.is_action_pressed("q"):
		show_highscores()

func start_game():
	var _err = get_tree().change_scene("res://NameMenu.tscn")
	
func show_highscores():
	var _err = get_tree().change_scene("res://Highscores.tscn")