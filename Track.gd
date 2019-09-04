extends Spatial

var pad_scene = preload("res://Pad.tscn")
var bar_scene = preload("res://Bar.tscn")

var speed
var note_scale
var start_pos
var color
var controls
var bars

var bar_index = 0
var bar_instances = []

var finished = false

func setup(game, track):
	speed = game.speed
	note_scale = game.note_scale
	start_pos = game.start_pos
	color = track.color
	controls = track.controls
	var offset = []
	for _i in range(game.offset):
		offset.append({"notes": []})
	bars = offset + track.bars

func _process(delta):
	for bar_instance in bar_instances:
		bar_instance.translate(Vector3(0, 0, speed * delta))
		
		if bar_instance.get_global_transform().origin.z > 8:
			var deleted_instance = bar_instances.pop_front()
			for note in deleted_instance.note_instances:
				if note.allocation != null:
					var url = Game.get_server() + "/games/" + Game.get_game_id() + "/allocations/" + note.allocation
					var headers = ["Content-Type: application/json"]
					$HTTP_clear_allocation.request(url, headers, false, HTTPClient.METHOD_DELETE, "")
			
			deleted_instance.queue_free()
			
			if bar_index < len(bars):
				_create_bar(bars[bar_index])
			else:
				finished = true

func _ready():
	_create_pad()
	
	# Create the initial 3 bars
	for i in range(0, 3):
		_create_bar(bars[i])
	
func _create_bar(bar):
	var bar_instance = bar_scene.instance()
	bar_instance.setup(self, bar)
	bar_instance.translate(Vector3(0, 0, -bar_instances.size() * 8))
	add_child(bar_instance)
		
	bar_instances.append(bar_instance)
	bar_index += 1
	
func _create_pad():
	var pad_instance = pad_scene.instance()
	pad_instance.setup(self)
	add_child(pad_instance)