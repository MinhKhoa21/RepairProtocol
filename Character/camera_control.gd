class_name CameraController
extends Node3D

@onready var arm_ik: SkeletonIK3D = $"../RepairEmployeeVer3/rig_001/Skeleton3D/armIK"

var mouse_sensitivity: float = 0.003
var input_rotation: Vector3
var mouse_input: Vector2

var player: Player
var anchor: Node3D

var override_target: Node3D = null

func _ready() -> void:
	player = get_parent()
	
	top_level = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if arm_ik: arm_ik.start()
	
	if player and player.get("camera_controller_anchor"):
		anchor = player.camera_controller_anchor
	else:
		push_error("Bug here: Havent assign 'camera_controller_anchor' in script Player!")

func _input(event: InputEvent) -> void:
	if override_target != null: return
	
	if !GState.is_playing() and !GState.is_inspecting(): return
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_input.x += -event.relative.x * mouse_sensitivity
		mouse_input.y += -event.relative.y * mouse_sensitivity

func _process(delta: float) -> void:
	#Top Level is Override
	if override_target != null:
		global_transform = override_target.global_transform
		return 
	
	if !player or !anchor: return
	
	input_rotation.y += mouse_input.x
	input_rotation.x += mouse_input.y
	mouse_input = Vector2.ZERO 
	
	input_rotation.x = clampf(input_rotation.x, deg_to_rad(-40), deg_to_rad(80))
	
	#(Yaw)
	player.global_rotation.y = input_rotation.y
	
	#(Bitch)
	anchor.rotation = Vector3(input_rotation.x, 0, 0)
	
	global_transform = anchor.global_transform

func set_cutscene_mode(target: Node3D):
	override_target = target

func reset_camera_mode():
	var current_rot = global_rotation
	input_rotation.y = current_rot.y
	input_rotation.x = current_rot.x
	override_target = null
