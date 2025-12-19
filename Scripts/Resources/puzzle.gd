extends Resource
class_name Task

enum task_type {SHORT, MEDIUM, LONG}
static var task_weight:Dictionary[int, float] = {
	task_type.SHORT:0.15,
	task_type.MEDIUM:0.25,
	task_type.LONG:0.35
}
signal succeed

var task_name:StringName = ""
var status:bool = false:
	set(val):
		if val && !status: succeed.emit()
		status = val
var level:int = task_type.SHORT
var weight:float = 0.1

#func status_check():
	#status = sub_tasks.all(func(x): return x.status)

func tick(): status = true
func untick(): status = false

func _init(_task_name:StringName, _task_type:int) -> void:
	task_name = _task_name
	level = _task_type
	weight = task_weight[_task_type]

static func short() -> float: return task_weight[task_type.SHORT]
static func medium() -> float: return task_weight[task_type.MEDIUM]
static func long() -> float: return task_weight[task_type.LONG]
static func short_task() -> Task: return Task.new("", task_type.SHORT)
static func medium_task() -> Task: return Task.new("", task_type.MEDIUM)
static func long_task() -> Task: return Task.new("", task_type.LONG)
