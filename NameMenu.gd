extends Control

var active_selector = 0

var characters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"]
var selectors = [0, 0, 0]

func _process(delta):
	var controls = $menu/center/selectors.get_children()
	var index = 0
	for control in controls:
		if index == active_selector:
			control.get_node("up").texture = load("res://up_arrow.png")
			control.get_node("down").texture = load("res://down_arrow.png")
		else:
			control.get_node("up").texture = load("res://up_arrow_inactive.png")
			control.get_node("down").texture = load("res://down_arrow_inactive.png")

		control.get_node("character").text = characters[selectors[index]]
		
		index += 1

func _input(event):
	if event.is_action_pressed("w"):
		next_character()
		
	if event.is_action_pressed("s"):
		prev_character()
		
	if event.is_action_pressed("a"):
		prev_selector()
		
	if event.is_action_pressed("d"):
		next_selector()
		
	if event.is_action_pressed("q"):
		get_tree().change_scene("res://MainMenu.tscn")
		
	if event.is_action_pressed("e"):
		Game.set_player_id(get_name())
		get_tree().change_scene("res://GameMenu.tscn")

func get_name():
	var first = characters[selectors[0]]
	var second = characters[selectors[1]]
	var third = characters[selectors[2]]
	return first+second+third

func next_selector():
	active_selector += 1
	if active_selector > len(selectors)-1:
		active_selector = 0
		
func prev_selector():
	active_selector -= 1
	if active_selector < 0:
		active_selector = len(selectors)-1
		
func next_character():
	selectors[active_selector] += 1
	if selectors[active_selector] > len(characters)-1:
		selectors[active_selector] = 0
	
func prev_character():
	selectors[active_selector] -= 1
	if selectors[active_selector] < 0:
		selectors[active_selector] = len(characters)-1