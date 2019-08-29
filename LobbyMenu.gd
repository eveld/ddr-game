extends Control

var home_ready = false
var away_ready = false

var home_id = ""
var away_id = ""

func _process(delta):
	if home_ready && away_ready:
		start_game()
		
	if home_ready:
		$menu/center/options/home/avatar.texture = load("res://ready.png")
	else:
		$menu/center/options/home/avatar.texture = load("res://waiting.png")
		
	if away_ready:
		$menu/center/options/away/avatar.texture = load("res://ready.png")
	else:
		$menu/center/options/away/avatar.texture = load("res://waiting.png")
		
	$menu/center/options/home/name.text = home_id
	$menu/center/options/away/name.text = away_id

func _input(event):
	if event.is_action_pressed("e"):
		player_ready()
		
	if event.is_action_pressed("q"):
		leave_game()

func _on_refresh_game_timeout():
	var url = Game.get_server() + "/games/" + Game.get_game_id()
	var headers = ["Content-Type: application/json"]
	$HTTP_get_game.request(url, headers, false, HTTPClient.METHOD_GET, "")

func _on_HTTP_get_game_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		
		print(response)
		
		home_id = response.home_id
		home_ready = response.home_ready
		
		away_id = response.away_id
		away_ready = response.away_ready

func player_ready():
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/ready?player=" + Game.get_player_id()
	var headers = ["Content-Type: application/json"]
	$HTTP_player_ready.request(url, headers, false, HTTPClient.METHOD_POST, "")

func _on_HTTP_player_ready_request_completed( result, response_code, headers, body ):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		
func start_game():
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/start"
	var headers = ["Content-Type: application/json"]
	$HTTP_start_game.request(url, headers, false, HTTPClient.METHOD_POST, "")

func _on_HTTP_start_game_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		get_tree().change_scene("res://Main.tscn")

func leave_game():
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/leave?player=" + Game.get_player_id()
	var headers = ["Content-Type: application/json"]
	$HTTP_leave_game.request(url, headers, false, HTTPClient.METHOD_POST, "")

func _on_HTTP_leave_game_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		get_tree().change_scene("res://GameMenu.tscn")
