extends Spatial

var track_scene = preload("res://Track.tscn")

var tempo
var bar_length
var quarter_time
var speed
var note_scale
var start_pos

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func _ready():
	var data = _read_audio("res://audio.json")
	
	tempo = data.tempo
	bar_length = 8
	quarter_time = 60 / float(tempo)
	speed = bar_length / float(4 * quarter_time)
	note_scale = bar_length / float(4 * 400)
	start_pos = data.start_pos / float(400 * quarter_time)
	
	_create_tracks(data.tracks)
	
	_center_camera(data.tracks.size())
	
	$Music.play()
	
func _center_camera(tracks):
	$Camera.translate(Vector3(tracks / 2, 0, 0.5))
	
func _create_tracks(tracks):
	var index = 0
	for track in tracks:
		var track_instance = track_scene.instance()
		track_instance.setup(self, track)
		track_instance.translate(Vector3(index, 0, 0))
		add_child(track_instance)
		
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