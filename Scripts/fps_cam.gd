extends Camera3D
class_name FPSCam

func _ready() -> void:
	pass

func get_forward() -> Vector3:
	var dir = -global_transform.basis.z
	dir.y = 0
	return dir.normalized()

func get_right() -> Vector3:
	var dir = global_transform.basis.x
	dir.y = 0
	return dir.normalized()

func force_look_at(target_pos: Vector3):
	pass
