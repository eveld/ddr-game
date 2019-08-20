extends Node

var songs = ["first song", "second song"]
var players = 1
var max_players = 2

var score = 0
var is_master = false
var song_index = 0
var player_index = 0

var game_id = ""
var player_id = ""

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
	
func next_player():
	players += 1
	if players > max_players:
		players = 1

func prev_player():
	players -= 1
	if players < 1:
		players = max_players

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
	
func get_players():
	return players