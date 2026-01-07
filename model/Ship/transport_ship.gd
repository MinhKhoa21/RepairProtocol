extends Vehicle

@onready var ani_tree: AnimationTree = $AnimationTree
@export var one_shot_name:Array[StringName]
@export var state_machine_name:Array[StringName]
@export var ias:Array[InteractArea]
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
	var front_left_repair: RepairPoint = $Fixpoint/FrontLeftRepair
	var front_right_repair: RepairPoint = $Fixpoint/FrontRightRepair
	var rear_left_repair: RepairPoint = $Fixpoint/RearLeftRepair
	var rear_right_repair: RepairPoint = $Fixpoint/RearRightRepair

	var front_door_left_ia: InteractArea = $Fix_Opener_F1/FrontDoorLeft_ia
	var front_door_right_ia: InteractArea = $Fix_Opener_F2/FrontDoorRight_ia
	var rear_door_left_2_ia: InteractArea = $FDB_H1_L2/RearDoorLeft2_ia
	var rear_door_left_1_ia: InteractArea = $FDB_H1_L1/RearDoorLeft1_ia
	var read_door_right_1_ia: InteractArea = $FDB_H2_R1/ReadDoorRight1_ia
	var rear_door_right_2_ia: InteractArea = $FDB_H2_R2/RearDoorRight2_ia

	ColKit.set_interact(front_left_repair, front_door_left_ia.flip)
	ColKit.set_interact(front_right_repair, front_door_right_ia.flip)
	ColKit.set_interact(rear_left_repair, (rear_door_left_1_ia.flip && rear_door_left_2_ia.flip))
	ColKit.set_interact(rear_right_repair, (read_door_right_1_ia.flip && rear_door_right_2_ia.flip))
