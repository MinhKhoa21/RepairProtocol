extends Resource
class_name RayKit

static func hide_from_ray(area:Area3D, _bool = true):
	area.set_collision_layer_value(7, _bool)
	area.set_collision_layer_value(5, !_bool)
	print(area.get_collision_layer_value(7))
