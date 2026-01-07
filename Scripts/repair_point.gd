extends InteractArea
class_name RepairPoint

#var task:Task
var damaged:bool = false
var scanned:bool = false:
	set = set_scanned
func set_scanned(a):
	scanned = a
	manual_toggel(a)

func _ready() -> void:
	manual_toggel(false)
	ColKit.set_interact(self, false)
