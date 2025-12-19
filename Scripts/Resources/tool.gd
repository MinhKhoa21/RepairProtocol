extends Item
class_name Tool

@export var packed_scene:PackedScene

func _init(_item_name:StringName = "", p_scene:PackedScene = null) -> void:
	super(_item_name, false)
	packed_scene = p_scene
