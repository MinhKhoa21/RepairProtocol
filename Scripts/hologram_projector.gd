extends Node3D

@onready var hologram: Node3D = $Hologram
@export var hologram_shader:ShaderMaterial
var meshes:Array
var ship_mesh

func _ready() -> void:
	hologram_cache()

func _physics_process(delta: float) -> void:
	var cur_ship_mesh = Watcher.current_ship.main_mesh
	if ship_mesh != cur_ship_mesh:
		if cur_ship_mesh == null:
			hologram.visible = false
		else:
			hologram.visible = true
			ship_mesh = cur_ship_mesh
			hologram_cache()
			hologram.add_child(load(ship_mesh).instantiate())
			project()

func convert_hologram(arr:Array):
	#var mat := ShaderMaterial.new()
	#mat.shader = preload("res://ShaderMaterial/ship_ui.gdshader")
	
	for i:MeshInstance3D in arr:
		i.set_surface_override_material(0, hologram_shader)

func project():
	#hologram_cache()
	meshes = hologram.get_child(0).get_children(true).filter(func(x): return x is MeshInstance3D)
	convert_hologram(meshes)

func hologram_cache():
	for i in hologram.get_children(): i.queue_free()
