extends Control

func _input(event):
	if event.is_action_pressed("e"):
		start_game()
		
	if event.is_action_pressed("q"):
		show_highscores()
		
func _on_Play_pressed():
	start_game()
	
func start_game():
	get_tree().change_scene("res://NameMenu.tscn")
	
func show_highscores():
	print("highscores")