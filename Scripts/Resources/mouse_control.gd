extends Control
class_name MouseControl

var can_hold:bool = false
var held:bool = false: set = set_held
signal pressed(_btn:int)
signal released(_btn:int)

func _ready():
	pressed.connect(func(_btn):
		if _btn == MOUSE_BUTTON_LEFT:
			can_hold = true
			add_child(TimerKit.generate_timer(0.15, func(): held = true))
		)
	released.connect(func(_btn):
		if _btn == MOUSE_BUTTON_LEFT:
			can_hold = false
		)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		pressed.emit(MOUSE_BUTTON_LEFT)
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_released():
		released.emit(MOUSE_BUTTON_LEFT)
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed():
		pressed.emit(MOUSE_BUTTON_RIGHT)
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.is_released():
		released.emit(MOUSE_BUTTON_RIGHT)

func set_held(a):
	if !can_hold && a: return
	held = a

func snap_cardinal() -> int:#[left, up, right, down][0, 1, 2, 3]
	var delta:Vector2 = get_global_mouse_position() - get_global_rect().get_center()
	if absf(delta.x) > absf(delta.y): return 0 if signf(delta.x) < 0 else 2
	else: return 1 if signf(delta.y) < 0 else 3
