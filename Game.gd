extends Node

var songs = ["first song", "second song"]
var players = 1
var max_players = 2

var score = 0
var is_master = false
var song_index = 0
var player_index = 0

func increase_score(amount):
	score += amount
	
func decrease_score(amount):
	score -= amount
	
func set_master():
	is_master = true
	
func reset_master():
	is_master = false
	
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