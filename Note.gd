extends Spatial

var color = Color()

var is_colliding = false
var is_collected = false
var pad

func setup(bar):
	color = bar.color

func _process(delta):
	if is_colliding && pad.is_collecting:
#		var note_pos = get_node("Area").get_pos()
#		var pad_pos = pad.get_pos()
		
#		var distance = note_pos.distance_to(pad_pos)
#		print(distance)
		
		is_collected = true
		hide()
	
func _ready():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$MeshInstance.set_surface_material(0, material)

func _on_area_entered(area):
	if area.is_in_group("Pad"):
		is_colliding = true
		pad = area.get_parent()

func _on_area_exited(area):
	if area.is_in_group("Pad"):
		is_colliding = false