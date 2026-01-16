extends Node3D
class_name Vehicle

enum ship_type {
	Transportship, #Small carrier, tanky
	Frigate, #jack of all trades
	Flanker, #High maneuver
	Escort, #Fast, better weaponry
	Satelite #Slow, fragile, insanely high shield and energy
}

@export var level_scale:float = 1
@export var main_mesh:StringName
@export var ship_name:String
@export var type:ship_type
@export var engine:int
@export var energy_core:int
@export var hull:float
@export var shield:float

@export var repair_point:Array[RepairPoint]
var damaged_parts:Array[RepairPoint] = []
var puzzles:Array = [] #[repair_point, puzzle] [Node3D, Node3D]
const a_rp = 0
const a_puz = 1

var status:float = 100:
	set(val):
		status = val
		print(val)
var part_percent:float

func _ready() -> void:
	part_percent = 100.0/repair_point.size()
	var damaged_point_num:int = randi_range(roundi(repair_point.size()/2), repair_point.size())
	for i in range(damaged_point_num):
		var damaged_point_i = (repair_point.filter(func(x): return !damaged_parts.has(x)).pick_random() as RepairPoint)
		damaged_point_i.set_damaged_and_unscanned()
		damaged_parts.append(damaged_point_i)
		status -= part_percent
	Watcher.repaired.connect(func(rp):
		if !rp.damaged:
			status += part_percent
			if status >= 100: Watcher.garage.yeet()
		)

func toggle_fix_points(): pass

func save_transform(node3d:Node3D, _var:Transform3D):
	_var = node3d.transform
	node3d.queue_free()
