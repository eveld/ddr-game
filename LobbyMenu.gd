extends Control

var home_ready = false
var away_ready = false
var all_ready = false

var requesting_game = false
var starting_game = false

var home_id = ""
var away_id = ""

func _process(_delta):
	if all_ready && !starting_game:
		start_game()
		
	if home_ready:
		$menu/options/home/avatar.texture = load("res://ready.png")
	else:
		$menu/options/home/avatar.texture = load("res://waiting.png")
		
	if away_ready:
		$menu/options/away/avatar.texture = load("res://ready.png")
	else:
		$menu/options/away/avatar.texture = load("res://waiting.png")
		
	$menu/options/home/name.text = home_id
	$menu/options/away/name.text = away_id

func _input(event):
	if event.is_action_pressed("e"):
		player_ready()
		
	if event.is_action_pressed("q"):
		leave_game()

func _on_refresh_game_timeout():
	if !requesting_game:
		requesting_game = true
		var url = Game.get_server() + "/games/" + Game.get_game_id()
		var headers = ["Content-Type: application/json"]
		$HTTP_get_game.request(url, headers, false, HTTPClient.METHOD_GET, "")

func _on_HTTP_get_game_request_completed(_result, response_code, _headers, body):
	if(response_code == 200):
		requesting_game = false
		
		var response = JSON.parse(body.get_string_from_utf8()).result
		
		home_id = response.home_id
		home_ready = response.home_ready
		
		away_id = response.away_id
		away_ready = response.away_ready
		
		all_ready = false
		if home_id != "" && home_ready:
			if away_id == "":
				all_ready = true
			else:
				if away_ready:
					all_ready = true

func player_ready():
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/ready"
	var headers = ["Content-Type: application/json"]
	
	var query = JSON.print({
		"player": Game.get_player_id()
	})
	
	$HTTP_player_ready.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _on_HTTP_player_ready_request_completed(_result, response_code, _headers, _body ):
	if(response_code == 200):
		pass
		
func start_game():
	starting_game = true
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/start"
	var headers = ["Content-Type: application/json"]
	
	var query = JSON.print({})
	$HTTP_start_game.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _on_HTTP_start_game_request_completed(_result, response_code, _headers, _body):
	if(response_code == 200):
		var _err = get_tree().change_scene("res://Main.tscn")

func leave_game():
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/leave"
	var headers = ["Content-Type: application/json"]
	
	var query = JSON.print({
		"player": Game.get_player_id()
	})
	
	$HTTP_leave_game.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _on_HTTP_leave_game_request_completed(_result, response_code, _headers, _body):
	if(response_code == 200):
		var _err = get_tree().change_scene("res://GameMenu.tscn")
