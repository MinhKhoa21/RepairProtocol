extends Area3D
class_name InteractArea

@export var cooldown:float = 0
var on_cd:bool = false
var flip:bool = false
signal interacted
@onready var par:Node = get_parent()

func _ready() -> void:
	interacted.connect(func():
		flip = !flip
		if cooldown > 0:
			toggle_monitor()
			add_child(TimerKit.generate_timer(cooldown, toggle_monitor))
		)

func toggle_monitor():
	monitoring = !monitoring
	monitorable = !monitorable
