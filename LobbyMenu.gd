extends Control

var ready_icon = preload("res://ready.png")
var waiting_icon = preload("res://waiting.png")

var p1_ready = false
var p2_ready = false

var all_ready = false

func _ready():
	$p1.disabled = !Game.is_master()
	$p2.disabled = Game.is_master()

func _process(delta):
		$start.disabled = !all_ready
		
#
# Poll game
#
func _on_refresh_game_timeout():
	var url = Game.get_server() + "/games/" + Game.get_game_id()
	var headers = ["Content-Type: application/json"]
	$HTTP_get_game.request(url, headers, false, HTTPClient.METHOD_GET, "")

func _on_HTTP_get_game_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		$p1.text = response.home_id
		$p2.text = response.away_id
		
		all_ready = false
		
		p1_ready = response.home_ready
		if p1_ready:
			$p1.icon = ready_icon
		else:
			$p1.icon = waiting_icon

		if response.away_id != "":
			p2_ready = response.away_ready
			if p2_ready:
				$p2.icon = ready_icon
			else:
				$p2.icon = waiting_icon
				
			if p1_ready && p2_ready:
				all_ready = true
		else:
			if p1_ready:
				all_ready = true
#
# Ready player
#
func _on_ready_pressed():
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/ready?player=" + Game.get_player_id()
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
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/start"
	var headers = ["Content-Type: application/json"]
	$HTTP_start_game.request(url, headers, false, HTTPClient.METHOD_POST, "")

func _on_HTTP_start_game_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		get_tree().change_scene("res://Main.tscn")


func _on_back_pressed():
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/leave?player=" + Game.get_player_id()
	var headers = ["Content-Type: application/json"]
	$HTTP_leave_game.request(url, headers, false, HTTPClient.METHOD_POST, "")

func _on_HTTP_leave_game_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		get_tree().change_scene("res://GameMenu.tscn")
