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
	get_tree().change_scene("res://LobbyMenu.tscn")

func _on_back_pressed():
	get_tree().change_scene("res://GameMenu.tscn")