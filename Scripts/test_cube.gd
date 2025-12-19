extends RigidBody3D

var task:Task

func _ready() -> void:
	task = $InteractArea/Control2.task
	task.task_name = "Light up the cube."
