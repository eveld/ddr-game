extends Spatial

var note_scene = preload("res://Note.tscn")

var notes
var note_scale

var color

func setup(track, bar):
	notes = bar.notes
	note_scale = track.note_scale
	color = track.color
	
func _ready():
	for note in notes:
		var note_instance = note_scene.instance()
		note_instance.setup(self)
		note_instance.translate(Vector3(0, 0, -note.pos * note_scale))
		add_child(note_instance)