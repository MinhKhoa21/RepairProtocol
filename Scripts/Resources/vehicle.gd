extends Node
class_name Vehicle

var status:float = 1
var tasks:Array[Task] = []

func _ready() -> void:
	status -= randf_range(0.3, 0.8)
	set_tasks(1-status)

func set_tasks(damaged:float):
	var rand_arr:Array[Task] = []
	rand_arr.append(Task.short_task())
	if damaged >= Task.medium(): rand_arr.append(Task.medium_task())
	if damaged >= Task.long(): rand_arr.append(Task.long_task())
	var add_task:Task = rand_arr.pick_random()
	tasks.append(add_task)
	if damaged > 0: set_tasks(damaged - add_task.weight)
