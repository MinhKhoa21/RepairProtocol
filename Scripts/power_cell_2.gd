extends Node3D

@export var stand_pos:Node3D
@export var ui_cam_pos:Node3D
@onready var ani: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$InteractArea.interacted.connect(extract)

func extract():
	pass

func insert():
	pass
