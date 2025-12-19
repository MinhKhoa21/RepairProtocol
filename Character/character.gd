extends CharacterBody3D
class_name Character

@export var ani:AnimationPlayer
@export_node_path("LimboHSM", "BTPlayer") var limbo_path
var limbo_player
@export var stat:Stats

func _ready() -> void:
	limbo_player = get_node(limbo_path)
