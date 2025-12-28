extends Node3D

var current_highlighted_part: MeshInstance3D = null

func _ready():
	Watcher.scan_hit.connect(_on_scan_hit)
	Watcher.scan_cleared.connect(_on_scan_cleared)

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
