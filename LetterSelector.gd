extends Control

var characters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"]
var index = 0

func _process(delta):
	$character.text = characters[index]

func _on_prev_pressed():
	prev_character()

func _on_next_pressed():
	next_character()

func prev_character():
	index -= 1
	if index < 0:
		index = len(characters)-1
	
func next_character():
	index += 1
	if index > len(characters)-1:
		index = 0

func get_character():
	return characters[index]