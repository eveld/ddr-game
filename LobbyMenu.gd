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
		
	if Game.is_master():
		$p2.disabled = true
	else:
		$p1.disabled = true

func _process(delta):
	if players == 1:
		$start.disabled = !p1_ready
	else:
		$start.disabled = !(p1_ready && p2_ready)


func _on_Back_pressed():
	get_tree().change_scene("res://GameMenu.tscn")

#
# Ready player
#
func _on_P1_pressed():
	_player_ready(Game.get_player_id())

func _on_P2_pressed():
	_player_ready(Game.get_player_id())

func _player_ready(player):
	var url = "http://localhost:9090/games/" + Game.get_game_id() + "/ready?player=" + player
	var headers = ["Content-Type: application/json"]
	$HTTP_player_ready.request(url, headers, false, HTTPClient.METHOD_POST, "")

func _on_HTTP_player_ready_request_completed( result, response_code, headers, body ):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		
		p1_ready = response.home_ready
		if p1_ready:
			$p1.icon = ready_icon
		else:
			$p1.icon = waiting_icon
			
		p2_ready = response.away_ready
		if p2_ready:
			$p2.icon = ready_icon
		else:
			$p2.icon = waiting_icon

#
# Start the game
#
func _on_start_pressed():
	_start_game()

func _start_game():
	var url = "http://localhost:9090/games/" + Game.get_game_id() + "/start"
	var headers = ["Content-Type: application/json"]
	$HTTP_start_game.request(url, headers, false, HTTPClient.METHOD_POST, "")

func _on_HTTP_start_game_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		get_tree().change_scene("res://Main.tscn")
