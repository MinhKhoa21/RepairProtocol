extends Resource
class_name TimerKit

static func generate_timer(duration, funcs:Callable, oneshot = true) -> Timer:
	var tim:Timer = Timer.new()
	tim.timeout.connect(funcs)
	if oneshot: tim.timeout.connect(func(): tim.queue_free())
	tim.wait_time = duration
	tim.one_shot = oneshot
	tim.autostart = true
	return tim

static func echo_timer(duration:float, interval:float, funcs:Callable, node:Node):
	if duration < interval: return
	var tim = generate_timer(interval, funcs)
	node.add_child(tim)
	tim.timeout.connect(func(): echo_timer(duration - interval, interval, funcs, node))

static func delta_timer(duration:float, delta:float, funcs:Callable, node:Node):
	var tim:Timer = generate_timer(delta, funcs, false)
	var func1:= func(): tim.queue_free()
	var stop:Timer = generate_timer(duration, func1)
	node.add_child(stop)
	node.add_child(tim)

static func tween_method_oneshot(node:Node, call:Callable, from_var, to_var, duration:float = 1):
	var tween = node.create_tween()
	tween.tween_method(call, from_var, to_var, duration)
	tween.finished.connect(tween.kill)
	
	
