class_name CameraController
extends Node3D

#@onready var camera: Camera3D = $Camera3D
#@onready var aim_target: Marker3D = $Camera3D/AimTarget
@onready var arm_ik: SkeletonIK3D = $"../RepairEmployeeVer3/rig_001/Skeleton3D/armIK"

#var player_controller: Player
var input_rotation: Vector3
var mouse_input: Vector2
var mouse_sensitivity: float = 0.005
var par:Node
var offset:Vector3


var use_interpolation: bool = false
var circle_strafe: bool = true

func _ready() -> void:
	par = get_parent()
	offset = position
	top_level = true
	#player_controller = get_parent()
	arm_ik.start()

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#mouse_input.x += -event.screen_relative.x * mouse_sensitivity
		#mouse_input.y += -event.screen_relative.y * mouse_sensitivity
		#
	#if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		#if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#else:
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if !GState.is_playing(): return
	global_position = par.global_position + offset * Vector3(0, par.scale.y, 0)
	#input_rotation.x = clampf(input_rotation.x + mouse_input.y, deg_to_rad(-50), deg_to_rad(80))
	#input_rotation.y += mouse_input.x
#
	## Quay player (yaw)
	#player_controller.rotation.y = input_rotation.y
#
	## Cập nhật hướng camera
	#player_controller.camera_controller_anchor.transform.basis = Basis.from_euler(Vector3(input_rotation.x, 0.0, 0.0))
	#global_transform = player_controller.camera_controller_anchor.get_global_transform_interpolated()
	#
#
	#mouse_input = Vector2.ZERO
