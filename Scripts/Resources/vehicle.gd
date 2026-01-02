extends Node
class_name Vehicle

enum ship_type {
	Transportship, #Small carrier, tanky
	Frigate, #jack of all trades
	Flanker, #High maneuver
	Escort, #Fast, better weaponry
	Satelite #Slow, fragile, insanely high shield and energy
}

@export var main_mesh:StringName
@export var ship_name:String
@export var type:ship_type
@export var engine:int
@export var energy_core:int
@export var hull:float
@export var shield:float

var status:float = 1
var tasks:Array[Task] = []
#var parts:Array[]

func _ready() -> void:
	status -= randf_range(0.5, 0.9)
	while status > 0:
		var task := Task.new_rand_task()
		tasks.append(task)
		status -= task.weight
	print(tasks.map(func(x): return x.weight))
	
