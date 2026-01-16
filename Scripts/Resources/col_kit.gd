extends Resource
class_name ColKit

static func set_interact(node:Node3D, _bool:bool):
	node.set_collision_layer_value(5, _bool)

static func set_scan(node:Node3D, _bool:bool):
	node.set_collision_layer_value(8, _bool)

static func set_cell(node:Node3D, _bool:bool):
	node.set_collision_layer_value(9, _bool)
