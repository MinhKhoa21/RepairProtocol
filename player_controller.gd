class_name PlayerController
extends CharacterBody3D

#@onready var camera_controller_anchor: Marker3D = $CameraControllerAnchor
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var skeleton: Skeleton3D = $RepairEmployeeVer2/rig_001/Skeleton3D
@onready var neck: Node3D = $Neck


var move_speed := 7.0
var strafe_speed_multiplier := 0.3 # crab speed 80%
var backward_speed_multiplier := 0.5 # backward speed 60%


var aim_strength: float = 0.4

func _ready() -> void:
	anim_tree.active = true
	
func _physics_process(delta: float) -> void:
	# 1. Lấy input (Local)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. (LOGIC TỐC ĐỘ MỚI) Quyết định tốc độ di chuyển
	var current_move_speed = move_speed # Mặc định là tốc độ đi tới

	if input_dir.y > 0:
		#Backward or scissor move use backward speed
		current_move_speed = move_speed * backward_speed_multiplier
	elif input_dir.y == 0 and input_dir.x != 0:
		#Crab move use crab speed
		current_move_speed = move_speed * strafe_speed_multiplier

	# Calculate Direction
	var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# New velocity for movement
	if direction != Vector3.ZERO:
		velocity.x = direction.x * current_move_speed
		velocity.z = direction.z * current_move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 10)
		velocity.z = move_toward(velocity.z, 0, delta * 10)
	move_and_slide()
	
	# Exchange world velocity to local velocity
	var local_velocity = global_transform.basis.inverse() * velocity
	var blend_vec = Vector2(local_velocity.x, local_velocity.z).normalized()
	
	# Push this vector 2 to blendspace2D
	anim_tree.set("parameters/Move/blend_position", blend_vec)

func _process(delta: float) -> void:
	global_rotation.y = neck.global_rotation.y
