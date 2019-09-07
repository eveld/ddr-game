extends Node

var players = 1

var score = 0
var is_master = false

var song_index = 0
var songs = ["maidentradesbleeps", "beatstruck", "audio"]

var game_id = ""
var player_id = ""

# q, a, w, s, e, d
var tiles = {
	"q": "nomad",
	"a": "vault",
	"w": "consul", 
	"s": "vagrant",
	"e": "packer", 
	"d": "terraform"
}

var game_server
var tile_server

var rng = RandomNumberGenerator.new()

var params = {}

func _ready():
	print(OS.get_user_data_dir())
	var args = OS.get_cmdline_args()
	params = parse_args(args)
		
	var tile_param = "led-server"
	if tile_param in params:
		tile_server = params[tile_param]
	else:
		tile_server = "http://localhost:9090"
	
	var game_param = "game-server"
	if game_param in params:
		game_server = params[game_param]
	else:
		game_server = "http://localhost:9000"

func parse_args(args):
	var p = {}
	for arg in args:
		var fields = arg.split("=", false, 1)
		var key = fields[0].trim_prefix("-").trim_prefix("-")
		p[key] = fields[1]
	return p

func get_tile_server():
	return tile_server

func get_tile_for_keys(keys):
	rng.set_seed(OS.get_unix_time())
	rng.randomize()
	var index = floor(rng.randi_range(0, len(keys)-1))
	return tiles[keys[index]]
	
func set_server(endpoint):
	game_server = endpoint
	
func get_server():
	return game_server

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