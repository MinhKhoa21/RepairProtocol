extends Area3D
class_name InteractArea

var on_cd:bool = false
var flip:bool = false
signal interacted
@onready var par:Node = get_parent()

func _ready() -> void:
	interacted.connect(func(): flip = !flip)

func toggle_monitor():
	monitoring = !monitoring
	monitorable = !monitorable
