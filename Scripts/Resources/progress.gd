extends Resource
class_name Progress

static var main_task:Task
static var task_arr:Array[Task] = []:
	set(val):
		task_arr = val.filter(func(x): return !x.status)

static func queue_task(task:Task): task_arr.append(task)
static func next_task():
	if main_task != null && main_task.status: return
	if task_arr.size() > 0: main_task = task_arr[0]
