extends Control

func _on_New_pressed():
	Game.set_master()
	get_tree().change_scene("res://CreateMenu.tscn")

func _on_Join_pressed():
	Game.reset_master()
	get_tree().change_scene("res://LobbyMenu.tscn")
	
func _on_Back_pressed():
	get_tree().change_scene("res://MainMenu.tscn")