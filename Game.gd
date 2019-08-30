extends Node

var players = 1
var max_players = 2

var score = 0
var is_master = false
var player_index = 0

var song_index = 0
var songs = ["maidentradesbleeps", "beatstruck", "audio"]

var game_id = ""
var player_id = ""
var server = ""

func _ready():
	# Set defaults from config file.
	var file = File.new()
	if(!file.file_exists("user://config.cfg")):
		file.open("user://config.cfg", File.WRITE)
		file.store_line("[server]")
		file.store_line("url=\"http://localhost:9090\"")
		file.store_line("[audio]")
		file.store_line("songs=[\"maidentradesbleeps\", \"beatstruck\", \"audio\"]")
		file.close()
	
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	if err == OK:
		server = config.get_value("server", "url")
		songs = config.get_value("audio", "songs")

func set_server(endpoint):
	server = endpoint
	
func get_server():
	return server

func set_game_id(id):
	game_id = id
	
func get_game_id():
	return game_id

func set_player_id(id):
	player_id = id
	
func get_player_id():
	return player_id

func increase_score(amount):
	score += amount
	
func decrease_score(amount):
	score -= amount
	
func set_master():
	is_master = true
	
func reset_master():
	is_master = false
	
func is_master():
	return is_master

func set_song(index):
	song_index = index

func get_song():
	return songs[song_index]

func get_songs():
	return songs
	
func get_players():
	return players