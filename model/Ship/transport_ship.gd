extends Vehicle

@onready var ani_tree: AnimationTree = $AnimationTree
#var front_door_left_os:AnimationNodeOneShot
#var front_door_right_os:AnimationNodeOneShot
#var rear_door_left_1_os:AnimationNodeOneShot
#var rear_door_left_2_os:AnimationNodeOneShot
#var rear_door_right_1_os:AnimationNodeOneShot
#var rear_door_right_2_os:AnimationNodeOneShot
@export var one_shot_name:Array[StringName]
@export var state_machine_name:Array[StringName]
@export var ias:Array[InteractArea]

var thrusters: Array[MeshInstance3D] = []

func _ready() -> void:
	super()
	for i:int in one_shot_name.size():
		ias[i].interacted.connect(func():
			if ias[i].flip: open_door(one_shot_name[i])
			else: close_door(state_machine_name[i])
			)
	var found_nodes = find_children("*", "MeshInstance3D", true, false)
	
	for node in found_nodes:
		if node.name.to_lower().contains("thruster"):
			thrusters.append(node)
			node.visible = false
	
	
	print(tasks.map(func(x): return x.weight))
	print(status)

func open_door(_one_shot:StringName):
	ani_tree.set("parameters/Others/%s/request"%[_one_shot], AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func close_door(_stm:StringName):
	(ani_tree["parameters/Others/%s/playback"%[_stm]] as AnimationNodeStateMachinePlayback).travel("Close")
