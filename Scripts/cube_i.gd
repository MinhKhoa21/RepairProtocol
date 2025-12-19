extends InteractArea

@export var puz:UIPuzzle
var light:OmniLight3D
var mesh:MeshInstance3D

func _ready() -> void:
	light = $"../OmniLight3D"
	mesh = $"../MeshInstance3D"
	interacted.connect(interact)

func interact():
	puz.start_puzzle(func():
		light.visible = true
		mesh.material_override.emission_enabled = true
		#task.tick()
		)
