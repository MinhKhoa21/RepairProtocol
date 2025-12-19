extends Node3D
class_name SnapPoint

var pos_node:Node3D
var rot_node:Node3D
var instant:bool = false
#var node_og:Transform3D
var snapping:bool = false:
	set(val):
		if val != snapping && !val:
			snapped.emit()
			#pos_node.transform = node_og
			pos_node = null
			instant = false
		snapping = val

signal snapped

func _process(delta: float) -> void:
	if snapping:
		var node_ground_pos:Vector3 = pos_node.global_position
		var node_rot:Vector3 = rot_node.global_rotation
		var this_ground_pos:Vector3 = Vector3(global_position.x, pos_node.global_position.y, global_position.z)
		var this_rot:Vector3 = short_rot()
		if !instant:
			pos_node.global_position = node_ground_pos.move_toward(this_ground_pos, delta*10)
			rot_node.global_rotation = node_rot.move_toward(this_rot, delta*10)
			snapping = !((pos_node.global_position - this_ground_pos).is_zero_approx() && (rot_node.global_rotation - this_rot).is_zero_approx())
		else:
			pos_node.global_position = this_ground_pos
			rot_node.global_rotation = this_rot
			snapping = false

func snap(_pos_node:Node3D, _rot_node:Node3D, _instant:bool = false):
	pos_node = _pos_node
	rot_node = _rot_node
	snapping = true
	instant = _instant
	#node_og = pos_node.transform

func short_rot() -> Vector3:
	return Vector3(
		rot_node.global_rotation.x + angle_difference(rot_node.global_rotation.x, global_rotation.x),
		rot_node.global_rotation.y + angle_difference(rot_node.global_rotation.y, global_rotation.y),
		rot_node.global_rotation.z + angle_difference(rot_node.global_rotation.z, global_rotation.z)
	)
