extends Spatial

var allocation
var color = Color()
var material = load("res://note_null.material")

var is_collected = false

func setup(bar, id):
	allocation = id
	color = Color(bar.color)

func collect():
	is_collected = true
	
func _ready():
	if allocation == null:
		var colored = SpatialMaterial.new()
		colored.albedo_color = color
		material = colored
#		material = load("res://note.material")
		
#		$label/node/id.text = allocation
		
	$mesh.set_surface_material(0, material)
	