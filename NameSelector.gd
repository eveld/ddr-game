extends Control

var active_selector = 0
var selectors = []

func _ready():
	selectors = [$first, $second, $third]

func get_name():
	var name = ""
	for selector in selectors:
		name += selector.get_character()
	return name
	
func next_selector():
	active_selector += 1
	if active_selector > len(selectors)-1:
		active_selector = 0

func prev_selector():
	active_selector -= 1
	if active_selector < 0:
		active_selector = len(selectors)-1
		
func next_character():
	selectors[active_selector].next_character()
	
func prev_character():
	index -= 1
	if index < 0:
		index = len(characters)-1