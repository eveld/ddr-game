extends Spatial

# Defaults
var controls = []
var color = Color()

# Check if a key is pressed
var is_pressed = false
var is_collecting = false
var is_colliding = false
var is_misstep = false

var note

func setup(track):
	color = track.color
	controls = track.controls

func _ready():
	set_process_input(true)
	
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$mesh.set_surface_material(0, material)
	
func _input(event):
	for control in controls:
		if event.is_action_pressed(control):
			is_pressed = true
			is_collecting = true
		if event.is_action_released(control):
			is_pressed = false
			is_collecting = false
			is_misstep = false

func _process(delta):
	if is_pressed:
		set_scale(Vector3(0.9, 0.9, 0.9))
	else:
		set_scale(Vector3(1, 1, 1))
		
	if is_colliding && is_collecting && !note.is_collected && !is_misstep:
		print(note.allocation)
		
		note.collect()
		note.hide()
		Game.increase_score(10)
	elif !is_colliding && !is_misstep && is_collecting:
		is_misstep = true
		Game.decrease_score(5)

func _on_area_entered(area):
	if area.is_in_group("note"):
		note = area.get_parent()
		is_colliding = true

func _on_area_exited(area):
	if area.is_in_group("note"):
		is_colliding = false