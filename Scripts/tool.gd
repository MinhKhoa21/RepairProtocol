extends Node3D

func _process(delta: float) -> void:
	if !HotBar.active_name == ItemNames.hammer:
		queue_free()
