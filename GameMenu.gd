extends Control

enum options {CREATE_GAME, JOIN_GAME}
var active_option

func _ready():
	active_option = options.CREATE_GAME
	$menu/options/create/button.disabled = false
	$menu/options/join/button.disabled = true

func _input(event):
	if event.is_action_pressed("e"):
		if active_option == options.CREATE_GAME:
			create_game()
		else:
			join_game()
		
	if event.is_action_pressed("q"):
		get_tree().change_scene("res://MainMenu.tscn")
		
	if event.is_action_pressed("a"):
		active_option = options.CREATE_GAME
		$menu/options/create/button.disabled = false
		$menu/options/join/button.disabled = true
		
	if event.is_action_pressed("d"):
		active_option = options.JOIN_GAME
		$menu/options/create/button.disabled = true
		$menu/options/join/button.disabled = false

func create_game():
	Game.set_master()
	get_tree().change_scene("res://CreateMenu.tscn")
	
func join_game():
	Game.reset_master()
	get_tree().change_scene("res://JoinMenu.tscn")	