extends Control

var song_index = 0
var songs = []

func _ready():
	songs = Game.get_songs()

func _process(_delta):
	$menu/options/song.text = get_song()

func _input(event):
	if event.is_action_pressed("a"):
		next_song()
		
	if event.is_action_pressed("d"):
		prev_song()
		
	if event.is_action_pressed("e"):
		Game.set_song(song_index)
		create_game()
		
	if event.is_action_pressed("q"):
		get_tree().change_scene("res://GameMenu.tscn")

func next_song():
	song_index += 1
	if song_index > songs.size() -1:
		song_index = 0
		
func prev_song():
	song_index -= 1
	if song_index < 0:
		song_index = songs.size()-1
		
func get_song():
	return songs[song_index]

func create_game():
	var url = Game.get_server() + "/games/new"
	var headers = ["Content-Type: application/json"]
	
	var query = JSON.print({
		"player": Game.get_player_id(),
		"song": get_song()
	})
	
	$HTTP_create_game.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _on_HTTP_create_game_request_completed( result, response_code, headers, body ):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		Game.set_game_id(response.id)
		Game.set_player_id(response.home_id)
		
		print("game: " + Game.get_game_id())
		print("player: " + Game.get_player_id())
		
		get_tree().change_scene("res://LobbyMenu.tscn")