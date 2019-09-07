extends Spatial

var allocation
var product
var color = Color()
var material = load("res://note_null.material")

var is_collected = false

func setup(_bar, id, prod, clr):
	allocation = id
	product = prod
	color = Color(clr)

func collect():
	is_collected = true
	
func _ready():
	if allocation != null:
		var colored = SpatialMaterial.new()
		colored.albedo_color = color
		material = colored
		
		$label/node/id.text = allocation
		
	$area/collision/mesh.set_surface_material(0, material)
	