extends Node3D
class_name CNode3D

##The scale this node will take when added to the tree.
@export var compatible_scale:float = 1

func _ready() -> void:
	scale = Vector3(1, 1, 1)*compatible_scale
