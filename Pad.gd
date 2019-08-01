extends Spatial

# Defaults
var controls = []
var color = Color()

# Check if a key is pressed
var is_pressed = false
var is_collecting = false

func setup(track):
	color = track.color
	controls = track.controls

func _ready():
	set_process_input(true)
	
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$MeshInstance.set_surface_material(0, material)
	
func _input(event):
	for control in controls:
		if event.is_action_pressed(control):
			is_pressed = true
			is_collecting = true
		if event.is_action_released(control):
			is_pressed = false
			is_collecting = false

func _process(delta):
	if is_pressed:
		set_scale(Vector3(0.9, 0.9, 0.9))
	else:
		set_scale(Vector3(1, 1, 1))