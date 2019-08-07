extends Spatial

var pad_scene = preload("res://Pad.tscn")
var bar_scene = preload("res://Bar.tscn")

var speed
var note_scale
var start_pos
var color
var controls
var bars

var bar_instances = []

func setup(game, track):
	speed = game.speed
	note_scale = game.note_scale
	start_pos = game.start_pos
	color = track.color
	controls = track.controls
	bars = track.bars

func _process(delta):
#	if get_parent().game_started:
	for bar_instance in bar_instances:
		bar_instance.translate(Vector3(0, 0, speed * delta))

func _ready():
	_create_pad()
	
	_create_bars()
	
func _create_bars():
	for bar in bars:
		var bar_instance = bar_scene.instance()
		bar_instance.setup(self, bar)
		bar_instance.translate(Vector3(0, 0, -bar.index * 8 - start_pos))
		add_child(bar_instance)
		
		bar_instances.append(bar_instance)
	
func _create_pad():
	var pad_instance = pad_scene.instance()
	pad_instance.setup(self)
	add_child(pad_instance)