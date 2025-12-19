extends Node3D

var offset:Vector3
var par:Node3D

func _ready() -> void:
	par = get_parent()
	offset = position
	top_level = true

func _process(delta: float) -> void:
	if !GState.is_playing(): return
	global_position = par.global_position + offset 
