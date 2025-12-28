extends Node3D

@export var scanned_color: Color = Color(1.0, 0.2, 0.0, 1.0)
@onready var ship_model = $shipver2Hologram

func _ready():
	update_visuals_recursive(ship_model)
	
	Watcher.scan_hit.connect(func(_part_name):
		update_visuals_recursive(ship_model)
	)

func _notification(what):
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if is_visible_in_tree():
			update_visuals_recursive(ship_model)

func update_visuals_recursive(node: Node):
	if node == null: return

	if node.name in Watcher.scanned_parts:
		apply_color_scan(node)
	
	for child in node.get_children():
		update_visuals_recursive(child)

func apply_color_scan(node: Node):
	if not (node is MeshInstance3D): return

	var mat = node.get_surface_override_material(0)
	if !mat:
		mat = node.get_active_material(0)
	
	if mat and mat is ShaderMaterial:
		var is_scanned = mat.get_shader_parameter("is_scanned")
		
		if is_scanned == false:
			var new_mat = mat.duplicate()
			new_mat.set_shader_parameter("scan_color", scanned_color)
			new_mat.set_shader_parameter("is_scanned", true)
			
			node.set_surface_override_material(0, new_mat)
