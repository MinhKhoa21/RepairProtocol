extends VBoxContainer

var task_bar_path:StringName = "res://Scenes/task_bar.tscn"

func _ready() -> void:
	add_child(TimerKit.generate_timer(0.5, update, false))

func update():
	for i in get_children().filter(func(x): return x is not Timer): i.queue_free()
	#if Progress.main_task == null: return
	#add_task_bar(Progress.main_task)
	#if Progress.main_task.sub_tasks.is_empty(): return
	#for i:Task in Progress.main_task.sub_tasks:
		#add_task_bar(i)
	for i:Task in Progress.task_arr:
		add_task_bar(i)

func add_task_bar(t:Task):
	var task_bar:Control = load(task_bar_path).instantiate()
	var task_name:Label = ReferKit.find_type(task_bar.get_children(), "Label")
	var check_box:CheckBox = ReferKit.find_type(task_bar.get_children(), "CheckBox")
	add_child(task_bar)
	task_name.text = t.task_name
	check_box.button_pressed = t.status
	#print(t.task_name, t.status)
