extends Control

var ready_icon = preload("res://ready.png")
var waiting_icon = preload("res://waiting.png")

var players

var p1_ready = false
var p2_ready = false

func _ready():
	players = Game.get_players()
	if players == 1:
		$p2.hide()

func _process(delta):
	if players == 1:
		if p1_ready:
			get_tree().change_scene("res://Main.tscn")
	else:
		if p1_ready && p2_ready:
			get_tree().change_scene("res://Main.tscn")

func _on_P1_pressed():
	p1_ready = !p1_ready
	if p1_ready:
		$p1.icon = ready_icon
	else:
		$p1.icon = waiting_icon

func _on_P2_pressed():
	p2_ready = !p2_ready
	if p2_ready:
		$p2.icon = ready_icon
	else:
		$p2.icon = waiting_icon
	
func _on_Back_pressed():
	get_tree().change_scene("res://GameMenu.tscn")