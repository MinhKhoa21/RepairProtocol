extends Control
class_name UIPuzzle

signal complete
var task:Task

func _init(_task:Task = Task.short_task()) -> void:
	visible = false
	task = _task

func start_puzzle(calls:Callable):
	visible = true
	var func2:= func():
		calls.call()
		GState.play()
		if task != null: task.tick()
		queue_free()
	var func1:= func():
		add_child(TimerKit.generate_timer(0.8, func2))
	complete.connect(func1)
	GState.solve()
	grab_focus()
