extends Spatial

# Defaults
var controls = []
var color = Color()

var note

func setup(track):
	color = track.color
	controls = track.controls

func _ready():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$mesh.set_surface_material(0, material)
	
func _input(event):
	for control in controls:
		if event.is_action_pressed(control):
			collect()
		if event.is_action_released(control):
			release()

func collect():
	set_scale(Vector3(0.9, 0.9, 0.9))
	if is_instance_valid(note) && !note.is_collected:
		note.collect()
		
		# Award bonus points for non-existent allocations.
		if note.allocation:
			Game.increase_score(10)
			
			# Kill the allocation
			var url = Game.get_server() + "/allocations" + note.allocation + "/stop"
			var headers = ["Content-Type: application/json"]
			$HTTP_stop_allocation.request(url, headers, false, HTTPClient.METHOD_POST, "")
		else:
			Game.increase_score(50)
		
		note.hide()
		note = null
	else:
		Game.decrease_score(5)
	
func release():
	set_scale(Vector3(1, 1, 1))

func _on_area_entered(area):
	if area.is_in_group("note"):
		note = area.get_parent()

func _on_HTTP_stop_allocation_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		var id = JSON.parse(body.get_string_from_utf8()).result
		print("stopped " + id)
