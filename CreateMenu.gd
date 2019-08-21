extends Control

func _process(delta):
	$song_title.text = Game.get_song()
	
	var players = Game.get_players()
	if players == 1:
		$player_count.text = "1 player"
	else:
		$player_count.text = "%d players" % players

func _on_next_song_pressed():
	Game.next_song()

func _on_prev_song_pressed():
	Game.prev_song()

func _on_next_player_pressed():
	Game.next_player()

func _on_prev_player_pressed():
	Game.prev_player()

func _on_create_pressed():
	var url = Server.get_server() + "/games/new"
	var headers = ["Content-Type: application/json"]
	$HTTP_create_game.request(url, headers, false, HTTPClient.METHOD_POST, "")

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