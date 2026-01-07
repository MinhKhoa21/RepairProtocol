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

var status:float = 1
#var parts:Array[]

func _ready() -> void:
	var broke_points:int = randi_range(0, repair_point.size())+1
	for i in range(broke_points):
		var damaged_part = repair_point.pick_random()
