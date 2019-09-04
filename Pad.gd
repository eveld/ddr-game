extends Spatial

# Defaults
var controls = []
var left_color = Color()
var right_color = Color()

var note

func setup(track, colors):
	left_color = colors[0]
	right_color = colors[1]
	controls = track.controls

func _ready():
	var left_material = SpatialMaterial.new()
	left_material.albedo_color = left_color
	$control/left.set_surface_material(0, left_material)
	
	var right_material = SpatialMaterial.new()
	right_material.albedo_color = right_color
	$control/right.set_surface_material(0, right_material)
	
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
		
		var url = Game.get_tile_server() + "/led/" + note.product
		var headers = ["Content-Type: application/json"]
		$HTTP_dim_tile.request(url, headers, false, HTTPClient.METHOD_DELETE, "")
		
		# Award bonus points for non-existent allocations.
		if note.allocation:
			Game.increase_score(10)
			
			# Kill the allocation
			url = Game.get_server() + "/games/" + Game.get_game_id() + "/allocations/" + note.allocation + "/stop"
			headers = ["Content-Type: application/json"]
			var query = JSON.print({})
			$HTTP_stop_allocation.request(url, headers, false, HTTPClient.METHOD_POST, query)
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
		
		# Get the tile for the note and light it
		var url = Game.get_tile_server() + "/led/" + note.product
		var headers = ["Content-Type: application/json"]
		$HTTP_light_tile.request(url, headers, false, HTTPClient.METHOD_POST, "")

func _on_area_area_exited(area):
	if area.is_in_group("note"):
		if is_instance_valid(note):
			# Dim te tile
			var url = Game.get_tile_server() + "/led/" + note.product
			var headers = ["Content-Type: application/json"]
			$HTTP_dim_tile.request(url, headers, false, HTTPClient.METHOD_DELETE, "")
