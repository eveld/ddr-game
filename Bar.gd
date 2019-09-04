extends Spatial

var note_scene = preload("res://Note.tscn")

var notes
var note_scale

var note_instances = []

var controls = []
var colors = []

func setup(track, bar, ctrl):
	notes = bar.notes
	note_scale = track.note_scale
	colors = track.product_colors
	controls = ctrl
	
func _ready():
	# Fetch allocations from server
	var allocation_count = notes.size()
	if allocation_count > 0:
		var url = Game.get_server() + "/games/" + Game.get_game_id() + "/allocations?count=" + str(allocation_count)
		var headers = ["Content-Type: application/json"]
		$HTTP_get_allocations.request(url, headers, false, HTTPClient.METHOD_GET, "")
		
func _on_HTTP_get_allocations_request_completed(_result, response_code, _headers, body):
	if(response_code == 200):
		var allocations = JSON.parse(body.get_string_from_utf8()).result
		for note in notes:
			var note_instance = note_scene.instance()
			var product = Game.get_tile_for_keys(controls)
			var color = colors[product]
			note_instance.setup(self, allocations.pop_front(), product, color)
			note_instance.translate(Vector3(0, 0.3, -note.pos * note_scale))
			add_child(note_instance)
			
			note_instances.append(note_instance)