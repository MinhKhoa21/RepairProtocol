extends Vehicle

@onready var ani_tree: AnimationTree = $AnimationTree
@export var one_shot_name:Array[StringName]
@export var state_machine_name:Array[StringName]
@export var ias:Array[InteractArea]
@export var repair_point:Array[Area3D]
@export var engine_toggle:bool = false
var thrusters: Array[MeshInstance3D] = []

func _ready() -> void:
	#Watcher.current_ship = self
	super()
	togge_fix_points()
	for i:int in one_shot_name.size():
		ias[i].interacted.connect(func():
			if ias[i].flip: open_door(one_shot_name[i])
			else: close_door(state_machine_name[i])
			)
	var found_nodes = find_children("*", "MeshInstance3D", true, false)
	
	if !engine_toggle:
		for node in found_nodes:
			if node.name.to_lower().contains("thruster"):
				thrusters.append(node)
				node.visible = false
	
	

func open_door(_one_shot:StringName):
	ani_tree.set("parameters/Others/%s/request"%[_one_shot], AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	togge_fix_points()

func close_door(_stm:StringName):
	(ani_tree["parameters/Others/%s/playback"%[_stm]] as AnimationNodeStateMachinePlayback).travel("Close")
	togge_fix_points()

func togge_fix_points():
	RayKit.hide_from_ray($Fixpoint/FrontLeftRepair, !$Fix_Opener_F1/FrontDoorLeft_ia.flip)
	RayKit.hide_from_ray($Fixpoint/FrontRightRepair, !$Fix_Opener_F2/FrontDoorRight_ia.flip)
	
	
	
