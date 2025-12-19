extends MeshInstance3D
class_name Door
#@export var lever:Lever
var og_y:float
var changed_y:float
var open:bool = false
var opened:bool = false:
	set(val):
		if !opened && val: when_opened()
		opened = val
var count:int = 1
var task:Task

#signal denied

func _ready() -> void:
	task = Task.new("", 0)
	task.task_name = "Open the dooor."
	#lever.interacted.connect(func(on:bool): open = on)
	og_y = global_position.y
	changed_y = global_position.y - mesh.size.y - 0.1

func _process(delta: float) -> void:
	if open: global_position.y = max(changed_y, move_toward(global_position.y, changed_y, delta*4))
	else: global_position.y = min(og_y, move_toward(global_position.y, og_y, delta*4))
	opened = is_zero_approx(global_position.y - changed_y)

func when_opened():
	task.tick()

func open_door(_arr:Array[bool]):
	open = _arr.all(func(x): return x)

func close_door(): open = false
