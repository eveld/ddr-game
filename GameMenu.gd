extends Control

enum options {CREATE_GAME, JOIN_GAME}
var active_option
var create_button
var join_button

func _ready():
	active_option = options.CREATE_GAME

func _input(event):
	if event.is_action_pressed("e"):
		if active_option == options.CREATE_GAME:
			create_game()
		else:
			join_game()
		
	if event.is_action_pressed("q"):
		cancel_game()
		
	if event.is_action_pressed("a"):
		active_option = options.CREATE_GAME
		
	if event.is_action_pressed("d"):
		active_option = options.JOIN_GAME

func create_game():
	Game.set_master()
	get_tree().change_scene("res://CreateMenu.tscn")
	
func join_game():
	Game.reset_master()
	get_tree().change_scene("res://JoinMenu.tscn")
	
func cancel_game():
	get_tree().change_scene("res://MainMenu.tscn")