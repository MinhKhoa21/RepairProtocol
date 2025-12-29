extends Node
class_name Vehicle

@export var main_mesh:StringName
var status:float = 1
var tasks:Array[Task] = []

func _ready() -> void:
	status -= randf_range(0.5, 0.9)
	while status > 0:
		var task := Task.new_rand_task()
		tasks.append(task)
		status -= task.weight
	print(tasks.map(func(x): return x.weight))
	
