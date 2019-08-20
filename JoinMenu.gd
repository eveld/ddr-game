extends Control

var games_json = "[{\"id\": \"a\", \"started\": 3, \"away_id\": \"x\"}, {\"id\": \"b\", \"started\": 0, \"away_id\": \"\"}]"
var selected_game_id = ""
var games = JSON.parse(games_json).result

func _ready():
	var url = "http://localhost:9090/games"
	var headers = ["Content-Type: application/json"]
	$HTTP_get_games.request(url, headers, false, HTTPClient.METHOD_GET, "")

func _on_HTTP_get_games_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		for game in response:
			if (game.started == 0 && game.away_id == ""):
				selected_game_id = game.id
				$join.disabled = false
				break

func _on_cancel_pressed():
	get_tree().change_scene("res://GameMenu.tscn")

#
# Join game
#
func _on_join_pressed():
	var url = "http://localhost:9090/games/" + selected_game_id + "/join"
	var headers = ["Content-Type: application/json"]
	$HTTP_create_game.request(url, headers, false, HTTPClient.METHOD_POST, "")

func _on_HTTP_join_game_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		Game.set_game_id(response.id)
		Game.set_player_id(response.away_id)
		get_tree().change_scene("res://LobbyMenu.tscn")



