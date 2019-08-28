extends Control

var selected_game_id = ""

func _ready():
	var url = Game.get_server() + "/games"
	var headers = ["Content-Type: application/json"]
	$HTTP_get_games.request(url, headers, false, HTTPClient.METHOD_GET, "")

func _process(delta):
	$game.text = selected_game_id

func _input(event):
	if event.is_action_pressed("w"):
		$name_selector.next_character()
		
	if event.is_action_pressed("s"):
		$name_selector.prev_character()
	
	if event.is_action_pressed("a"):
		$name_selector.prev_selector()
		
	if event.is_action_pressed("d"):
		$name_selector.next_selector()

func _on_HTTP_get_games_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		selected_game_id = ""
		for game in response:
			if (game.started == 0 && game.away_id == "" && game.home_id != ""):
				selected_game_id = game.id
				break
				
		if selected_game_id != "":
			$join.disabled = false
			

func _on_refresh_games_timeout():
	var url = Game.get_server() + "/games"
	var headers = ["Content-Type: application/json"]
	$HTTP_get_games.request(url, headers, false, HTTPClient.METHOD_GET, "")

func _on_cancel_pressed():
	get_tree().change_scene("res://GameMenu.tscn")

#
# Join game
#
func _on_join_pressed():
	var url = Game.get_server() + "/games/" + selected_game_id + "/join"
	var headers = ["Content-Type: application/json"]
	
	var query = JSON.print({
		"away_id": $name_selector.get_name()
	})
	
	print(query)
	
	$HTTP_join_game.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _on_HTTP_join_game_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		Game.set_game_id(response.id)
		Game.set_player_id(response.away_id)
		get_tree().change_scene("res://LobbyMenu.tscn")