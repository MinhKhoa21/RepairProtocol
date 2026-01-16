extends Vehicle

@onready var ani_tree: AnimationTree = $AnimationTree
@export var hologram:StringName
@export var one_shot_name:Array[StringName]
@export var state_machine_name:Array[StringName]
@export var doors:Array[InteractArea]
@export var engine_toggle:bool = false

@onready var front_left_repair: RepairPoint = $Fixpoint/FrontLeftRepair
@onready var front_right_repair: RepairPoint = $Fixpoint/FrontRightRepair
@onready var rear_left_repair: RepairPoint = $Fixpoint/RearLeftRepair
@onready var rear_right_repair: RepairPoint = $Fixpoint/RearRightRepair

@onready var front_door_left_ia: InteractArea = $Fix_Opener_F1/FrontDoorLeft_ia
@onready var front_door_right_ia: InteractArea = $Fix_Opener_F2/FrontDoorRight_ia
@onready var rear_door_left_2_ia: InteractArea = $FDB_H1_L2/RearDoorLeft2_ia
@onready var rear_door_left_1_ia: InteractArea = $FDB_H1_L1/RearDoorLeft1_ia
@onready var read_door_right_1_ia: InteractArea = $FDB_H2_R1/ReadDoorRight1_ia
@onready var rear_door_right_2_ia: InteractArea = $FDB_H2_R2/RearDoorRight2_ia

var thrusters: Array[MeshInstance3D] = []
var front_left_puzzle_transform:Transform3D
var front_right_puzzle_transform:Transform3D
var rear_left_puzzle_transform:Transform3D
var rear_right_puzzle_transform:Transform3D

func _ready() -> void:
	super()
	#Watcher.current_ship = self
	#save_transform($FrontLeftPuzzleTemplate, front_left_puzzle_transform)
	#save_transform($FrontRightPuzzleTemplate, front_right_puzzle_transform)
	#save_transform($RearLeftPuzzleTemplate, rear_left_puzzle_transform)
	#save_transform($RearRightPuzzleTemplate, rear_right_puzzle_transform)
	togge_fix_points()
	for i:int in one_shot_name.size():
		doors[i].interacted.connect(func():
			if doors[i].flip: open_door(one_shot_name[i])
			else: close_door(state_machine_name[i])
			)
	var found_nodes = find_children("*", "MeshInstance3D", true, false)
	
	if !engine_toggle:
		for node in found_nodes:
			if node.name.to_lower().contains("thruster"):
				thrusters.append(node)
				node.visible = false
		
	for i:RepairPoint in damaged_parts:
		fix_point_init(i)

func open_door(_one_shot:StringName):
	ani_tree.set("parameters/Others/%s/request"%[_one_shot], AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	togge_fix_points()

func close_door(_stm:StringName):
	(ani_tree["parameters/Others/%s/playback"%[_stm]] as AnimationNodeStateMachinePlayback).travel("Close")
	togge_fix_points()

func togge_fix_points():
	ColKit.set_interact(front_left_repair, front_door_left_ia.flip)
	ColKit.set_interact(front_right_repair, front_door_right_ia.flip)
	ColKit.set_interact(rear_left_repair, (rear_door_left_1_ia.flip && rear_door_left_2_ia.flip))
	ColKit.set_interact(rear_right_repair, (read_door_right_1_ia.flip && rear_door_right_2_ia.flip))

func fix_point_init(rp:RepairPoint):
	var puz:Puzzle = load(rp.puzzles.pick_random()).instantiate()
	rp.puzzle = puz
	add_child(puz)
	var puz_template = rp.puzzle_template[puz.puzzle_type]
	puz.transform = puz_template.transform
	puz_template.queue_free()
	puz.create_puzzle.emit()
	puzzles.append([rp, puz])
	puz.complete.connect(rp.repair)
	rp.interacted.connect(func(): puz.open_puzzle.emit())
