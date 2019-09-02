extends Spatial

var note_scene = preload("res://Note.tscn")

var notes
var note_scale

var note_instances = []

var color

func setup(track, bar):
	notes = bar.notes
	note_scale = track.note_scale
	color = track.color
	
func _ready():
	# Fetch allocations from server
	var allocation_count = notes.size()
	if allocation_count > 0:
		var url = Game.get_server() + "/games/" + Game.get_game_id() + "/allocations"
		var headers = ["Content-Type: application/json"]
		
		var query = JSON.print({
			"player": Game.get_player_id(),
			"count": allocation_count
	}	)
		
		$HTTP_get_allocations.request(url, headers, false, HTTPClient.METHOD_GET, query)
		
func _on_HTTP_get_allocations_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		var allocations = JSON.parse(body.get_string_from_utf8()).result
		for note in notes:
			var note_instance = note_scene.instance()
			note_instance.setup(self, allocations.pop_front())
			note_instance.translate(Vector3(0, 0.3, -note.pos * note_scale))
			add_child(note_instance)
			
			note_instances.append(note_instance)