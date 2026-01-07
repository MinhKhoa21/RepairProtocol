extends Resource
class_name ColKit

static func set_interact(node:Node3D, _bool:bool):
	node.set_collision_layer_value(5, _bool)
