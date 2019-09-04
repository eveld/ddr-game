extends Node

var players = 1

var score = 0
var is_master = false

var song_index = 0
var songs = ["maidentradesbleeps", "beatstruck", "audio"]

var game_id = ""
var player_id = ""
var server = "http://api.google.ddr.demo.gs"

# q, a, w, s, e, d
var tiles = {
	"q": "nomad",
	"a": "vault",
	"w": "consul", 
	"s": "vagrant",
	"e": "packer", 
	"d": "terraform"
}
var tile_server = "http://localhost:5000"

var rng = RandomNumberGenerator.new()

func _ready():
	print(OS.get_user_data_dir())
	get_tile_for_keys(["q", "a"])

func get_tile_server():
	return tile_server

func get_tile_for_keys(keys):
	rng.set_seed(OS.get_unix_time())
	rng.randomize()
	var index = floor(rng.randi_range(0, len(keys)-1))
	return keys[index]
	
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
	
func get_is_master():
	return is_master

func set_song(index):
	song_index = index

func get_song():
	return songs[song_index]

func get_songs():
	return songs
	
func get_players():
	return players