extends Node3D
class_name ShipHologram

@export var overall_material: ShaderMaterial
var current_highlighted_part: MeshInstance3D = null

func _ready():
	Watcher.scan_hit.connect(_on_scan_hit)
	Watcher.scan_cleared.connect(_on_scan_cleared)
	project()

func _exit_tree():
	if Watcher.scan_hit.is_connected(_on_scan_hit):
		Watcher.scan_hit.disconnect(_on_scan_hit)
	if Watcher.scan_cleared.is_connected(_on_scan_cleared):
		Watcher.scan_cleared.disconnect(_on_scan_cleared)

func _on_scan_hit(part_name: String):
	if current_highlighted_part and current_highlighted_part.name != part_name:
		_set_part_highlight(current_highlighted_part, false)
	
	var target_part = find_child(part_name, true, false)
	
	if target_part and target_part is MeshInstance3D:
		_set_part_highlight(target_part, true)
		current_highlighted_part = target_part

func _on_scan_cleared():
	if current_highlighted_part:
		_set_part_highlight(current_highlighted_part, false)
		current_highlighted_part = null

func _set_part_highlight(mesh_node: MeshInstance3D, active: bool):
	var mat = mesh_node.get_active_material(0)
	if mat:
		mat.set_shader_parameter("is_scanned", active)

func project():
	for i:MeshInstance3D in get_children().filter(func(x): return x is MeshInstance3D):
		i.material_override = overall_material.duplicate()
		

func set_override_color(mesh:MeshInstance3D, damage_stage:int):
	var cor:Color
	match damage_stage:
		1: cor = Color(1, 1, 0, 1)
		2: cor = Color(1, 0, 0, 1)
		_: cor = Color(0, 1, 0, 1)
	for i in get_children().filter(func(x): return x is MeshInstance3D):
		if i.name == mesh.name:
			(i.material_override as ShaderMaterial).set_shader_parameter("is_scanned", true)
			(i.material_override as ShaderMaterial).set_shader_parameter("scan_color", cor)
