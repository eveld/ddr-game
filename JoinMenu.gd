extends Control

var game_index = 0
var games = []

func _ready():
	var url = Game.get_server() + "/games"
	var headers = ["Content-Type: application/json"]
	$HTTP_get_games.request(url, headers, false, HTTPClient.METHOD_GET, "")

func _process(_delta):
	if games.size() > 0:
		$menu/options/game.text = get_game().home_id

func _input(event):
	if event.is_action_pressed("a"):
		next_game()
		
	if event.is_action_pressed("d"):
		prev_game()
		
	if event.is_action_pressed("e"):
		join_game()
		
	if event.is_action_pressed("q"):
		get_tree().change_scene("res://GameMenu.tscn")

func _on_HTTP_get_games_request_completed(_result, response_code, _headers, body):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		for game in response:
			if (game.started == 0 && game.away_id == "" && game.home_id != ""):
				games.append(game)

func next_game():
	game_index += 1
	if game_index > games.size() -1:
		game_index = 0
		
func prev_game():
	game_index -= 1
	if game_index < 0:
		game_index = games.size()-1

func get_game():
	return games[game_index]

func _on_refresh_games_timeout():
	var url = Game.get_server() + "/games"
	var headers = ["Content-Type: application/json"]
	$HTTP_get_games.request(url, headers, false, HTTPClient.METHOD_GET, "")

func join_game():
	var url = Game.get_server() + "/games/" + get_game().id + "/join"
	var headers = ["Content-Type: application/json"]
	
	var query = JSON.print({
		"player": Game.get_player_id()
	})
	
	$HTTP_join_game.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _on_HTTP_join_game_request_completed(_result, response_code, _headers, body):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		Game.set_game_id(response.id)
		Game.set_player_id(response.away_id)
		get_tree().change_scene("res://LobbyMenu.tscn")