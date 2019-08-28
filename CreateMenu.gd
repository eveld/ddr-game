extends Control

func _process(_delta):
	$song_title.text = Game.get_song()

func _input(event):
	if event.is_action_pressed("w"):
		$name_selector.next_character()
		
	if event.is_action_pressed("s"):
		$name_selector.prev_character()
	
	if event.is_action_pressed("a"):
		$name_selector.prev_selector()
		
	if event.is_action_pressed("d"):
		$name_selector.next_selector()

func _on_next_song_pressed():
	Game.next_song()

func _on_prev_song_pressed():
	Game.prev_song()

func _on_create_pressed():
	var url = Game.get_server() + "/games/new"
	var headers = ["Content-Type: application/json"]
	
	var query = JSON.print({
		"home_id": $name_selector.get_name(),
		"song": Game.get_song()
	})
	
	print(query)
	
	$HTTP_create_game.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _on_back_pressed():
	get_tree().change_scene("res://GameMenu.tscn")

func _on_HTTP_create_game_request_completed( result, response_code, headers, body ):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		Game.set_game_id(response.id)
		Game.set_player_id(response.home_id)
		
		print("game: " + Game.get_game_id())
		print("player: " + Game.get_player_id())
		
		get_tree().change_scene("res://LobbyMenu.tscn")