extends Spatial

var track_scene = preload("res://Track.tscn")

var tempo
var bar_length
var quarter_time
var speed
var note_scale
var start_pos
var offset

var countdown = 3
var track_count = 0
var track_instances = []

var game_over = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
			var _err = get_tree().reload_current_scene()
			
	if !game_over:
		$score_label.text = "%d" % Game.score
		
		# Animate the grid...
		$floor.get_surface_material(0).uv1_offset.z -= 0.05

func _ready():
	var data = _read_audio("res://" + Game.get_song() + ".json")
	var audio_file = "res://" + data.audio.download_link
	if File.new().file_exists(audio_file):
		var sfx = load(audio_file)
		$music.stream = sfx
	
	track_count = data.tracks.size()
	tempo = data.tempo
	offset = data.offset
	bar_length = 8
	quarter_time = 60 / float(tempo)
	speed = bar_length / float(4 * quarter_time)
	note_scale = bar_length / float(4 * 400)
	start_pos = data.start_pos / float(400 * quarter_time) + 3 * bar_length
		
	_create_tracks(data.tracks)
	_center_camera(track_count)
	
func _on_countdown_timer_timeout():
	if countdown == 0:
		$countdown_label.text = "go!"
	elif countdown < 0:
		$countdown_timer.stop()
		$countdown_label.hide()
		$music.play()
	else:
		$countdown_label.text = "%s" % countdown
		
	countdown -= 1
	
	
func _center_camera(track_count):
	$camera.translate(Vector3(track_count / 2, 0, 0.5))
	
func _create_tracks(tracks):
	var index = 0
	for track in tracks:
		var track_instance = track_scene.instance()
		track_instance.setup(self, track)
		track_instance.translate(Vector3(index, 0, 0))
		add_child(track_instance)
		
		track_instances.append(track_instance)
		
		index += 1
	
func _read_audio(path):
	var file = File.new()
	if not file.file_exists(path):
		print("ERROR: could not find %s" % path)
	file.open(path, file.READ)
	
	# Read the contents
	var text = file.get_as_text()
	file.close()
	
	# Parse the json to object
	var parsed = JSON.parse(text)
	if parsed.error != OK:
		print("ERROR: %s" % parsed.error)
		
	return parsed.result

func _on_music_finished():
	game_over = true
	$gameover_label.show()
	var url = Game.get_server() + "/games/" + Game.get_game_id() + "/scores/new"
	var headers = ["Content-Type: application/json"]
	
	var query = JSON.print({
		"player": Game.get_player_id(),
		"points": Game.score
	})
	
	$HTTPRequest_leave_game.request(url, headers, false, HTTPClient.METHOD_POST, query)
	$gameover_timer.start()

func _on_gameover_timer_timeout():
	var _err = get_tree().change_scene("res://Highscores.tscn")

func _on_HTTPRequest_leave_game_request_completed(_result, response_code, _headers, body):
	if(response_code == 200):
		pass