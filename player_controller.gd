class_name PlayerController
extends CharacterBody3D

#@onready var camera_controller_anchor: Marker3D = $CameraControllerAnchor
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var skeleton: Skeleton3D = $RepairEmployeeVer2/rig_001/Skeleton3D
@onready var neck: Node3D = $Neck


var move_speed := 7.0
var strafe_speed_multiplier := 0.8 # crab speed 80%
var backward_speed_multiplier := 0.6 # backward speed 60%
#var _current_input_dir := Vector2.ZERO
#var _last_position := Vector3.ZERO


var aim_strength: float = 0.4

func _ready() -> void:
	anim_tree.active = true
	
func _physics_process(delta: float) -> void:
	# 1. Lấy input (Local)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. (LOGIC TỐC ĐỘ MỚI) Quyết định tốc độ di chuyển
	var current_move_speed = move_speed # Mặc định là tốc độ đi tới

	if input_dir.y > 0:
		# Nếu đi lùi (hoặc lùi-chéo) -> dùng tốc độ lùi
		current_move_speed = move_speed * backward_speed_multiplier
	elif input_dir.y == 0 and input_dir.x != 0:
		# Nếu chỉ đi ngang (không tiến/lùi) -> dùng tốc độ ngang
		current_move_speed = move_speed * strafe_speed_multiplier

	# 3. Tính toán hướng di chuyển (World)
	var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# 4. Xử lý di chuyển (Movement) - Dùng tốc độ mới
	if direction != Vector3.ZERO:
		velocity.x = direction.x * current_move_speed # <--- Dùng tốc độ mới
		velocity.z = direction.z * current_move_speed # <--- Dùng tốc độ mới
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 10)
		velocity.z = move_toward(velocity.z, 0, delta * 10)
	move_and_slide()
	
	# Chuyển đổi velocity (world space) về hướng cục bộ (local space)
	var local_velocity = global_transform.basis.inverse() * velocity
	var blend_vec = Vector2(local_velocity.x, local_velocity.z).normalized()
	
	# Đẩy Vector2 MỚI này vào BlendSpace2D
	anim_tree.set("parameters/Move/blend_position", blend_vec)

func _process(delta: float) -> void:
	global_rotation.y = neck.global_rotation.y
