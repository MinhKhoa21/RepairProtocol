extends Character
class_name Player

@onready var cam_controller: CameraController = $Neck

@onready var arm_ik: SkeletonIK3D = $RepairEmployeeVer3/rig_001/Skeleton3D/armIK
@onready var holding_tool: Node3D = $RepairEmployeeVer3/rig_001/Skeleton3D/HandBone/Tools
@onready var carry_marker: Marker3D = $Neck/CarryMarker
@onready var arm_marker: Marker3D = $Neck/FPSCam/ArmMarker
@onready var cutscene_eyes: Marker3D = $RepairEmployeeVer3/rig_001/Skeleton3D/EyesBone/CutSceneEyes
@onready var scanner_hud = $ScannerHUD

@export var inventory:Storage
@export var fps_cam: FPSCam
@export var look_ray:RayCast3D
@export var pointer_label:Label
@export var camera_controller_anchor: Node3D


var dir:Vector3
var input_dir:Vector2 = Vector2.ZERO

var cd:bool = false
var hit:bool = false
var is_scan_active = false
var current_scanned_object: Node3D = null

func _ready() -> void:
	super()
	Watcher.input_hud.append($Control)
	HotBar.populate_hot_bar(inventory)
	Watcher.player = self
	Watcher.player_cam = fps_cam
	Watcher.carry = carry_marker
	Watcher.right_hand = holding_tool
	
	limbo_player.set_active(true)
	(limbo_player as LimboHSM).blackboard.bind_var_to_property(BBNames.direction, self, "dir")
	$AnimationTree.set("parameters/Movement/4/blend_position", -1)

func _process(delta: float) -> void:
	fps_cam.process_mode = ReferKit.flow(GState.game_state, [GState.gstate_enum.INSPECTING, GState.gstate_enum.PLAYING], [Node.PROCESS_MODE_DISABLED, Node.PROCESS_MODE_INHERIT])

func _physics_process(delta: float) -> void:
	#print(camera_controller_anchor.global_rotation)
	if GState.is_playing():
		movement_input()
		$AnimationTree.set("parameters/Movement/blend_position", input_dir)
		limbo_player.update(delta)
	
	display_pointer_safe() 
	
	if is_scan_active:
		handle_scanning()
	
	dir = velocity.normalized()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if look_ray.is_colliding():
			var collider = look_ray.get_collider()
			if collider is InteractArea:
				var ia:InteractArea = collider
				if !ia.on_cd: ia.interacted.emit()

	if event.is_action_pressed("mouse1") && GState.is_playing():
		hit = true

	if event.is_action_released("mouse1"):
		hit = false

	if event.is_action_pressed("run"):
		limbo_player.can_run = true
		$AnimationTree.set("parameters/Movement/4/blend_position", 1)

	if event.is_action_released("run"):
		limbo_player.can_run = false
		$AnimationTree.set("parameters/Movement/4/blend_position", -1)

	if event.is_action_pressed("tab"):
		if GState.is_playing(): GState.ware()
		elif GState.is_ware(): GState.play()

	if event.is_action_pressed("toggle_scan"):
		print("DEBUG: Activated Scanning!")
		
		if scanner_hud:
			is_scan_active = !is_scan_active
			scanner_hud.toggle_scan(is_scan_active)
		else:
			print("Bug Here: scanner hud is Null")


func movement_input():
	if !GState.is_playing():
		input_dir = Vector2.ZERO
		velocity = Vector3.ZERO
		return

	input_dir = Input.get_vector("move_left", "move_right", "move_down", "move_up")
	
	var move_dir = (fps_cam.get_forward() * input_dir.y + fps_cam.get_right() * input_dir.x).normalized()
	var speed:float = 1
	if limbo_player.can_run: speed = stat.run_speed
	else: speed = stat.speed
	velocity = Vector3(move_dir.x, 0, move_dir.z) * speed

func set_visual_layer_recursive(node: Node, layer_num: int, enable: bool):
	if node is VisualInstance3D:
		node.set_layer_mask_value(layer_num, enable)
	
	for child in node.get_children():
		set_visual_layer_recursive(child, layer_num, enable)


func handle_scanning():
	if not look_ray.enabled: look_ray.enabled = true
	look_ray.collide_with_bodies = true 
	
	if look_ray.is_colliding():
		var collider = look_ray.get_collider()
		var target_obj = null 
		
		if collider.get_collision_layer_value(3):
			target_obj = collider
		
		elif collider is InteractArea:
			var parent = collider.get_parent()
			
			if parent is CollisionObject3D and parent.get_collision_layer_value(3):
				target_obj = parent
			
			elif parent is VisualInstance3D and (parent.get_layer_mask_value(3) or parent.get_layer_mask_value(4)):
				target_obj = parent 
		
		if target_obj:
			if current_scanned_object != target_obj:
				print(">>> New Scanned: ", target_obj.name)
				
				reset_scanned_object()
				
				current_scanned_object = target_obj
				highlight_object(current_scanned_object)
				
				Watcher.register_scan(current_scanned_object.name) 
				Watcher.scan_hit.emit(current_scanned_object.name)
		else:
			reset_scanned_object()
	else:
		reset_scanned_object()

func highlight_object(obj):
	if obj:
		set_visual_layer_recursive(obj, 3, false) 
		set_visual_layer_recursive(obj, 4, true)

func reset_scanned_object():
	if current_scanned_object: 
		Watcher.scan_cleared.emit()
	
	if current_scanned_object and is_instance_valid(current_scanned_object):
		set_visual_layer_recursive(current_scanned_object, 4, false)
		set_visual_layer_recursive(current_scanned_object, 3, true)
	
	current_scanned_object = null


func display_pointer_safe() -> bool:
	if look_ray.is_colliding() && GState.is_playing():
		var collider = look_ray.get_collider()
		
		if collider is InteractArea:
			pointer_label.text = collider.par.name
			return true
		
		elif is_scan_active and current_scanned_object == collider:
			pointer_label.text = "Scanning: " + collider.name 
			return true
			
	pointer_label.text = ""
	return false

func display_cd():
	cd = true
	add_child(TimerKit.generate_timer(0.1, func(): cd = false))

func hand_snap(_transform:Transform3D):
	arm_ik.stop()
	arm_ik.target_node = ""
	arm_ik.target = _transform
	arm_ik.start(true)

func hand_snap_back():
	arm_ik.target_node = arm_marker.get_path()
	arm_ik.start()

func sequence_open_briefcase(target_tf: Transform3D, look_target_pos: Vector3, box_anim: AnimationPlayer, ui_marker: Node3D):
	var prev_state = GState.game_state
	GState.game_state = GState.gstate_enum.INSPECTING
	
	arm_ik.stop()
	
	input_dir = Vector2.ZERO
	velocity = Vector3.ZERO
	$AnimationTree.set("parameters/Movement/blend_position", Vector2.ZERO)
	
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	var target_pos = target_tf.origin
	target_pos.y = global_position.y
	tween.tween_property(self, "global_position", target_pos, 0.5)
	
	var ideal_eye_pos = target_tf.origin
	ideal_eye_pos.y = cam_controller.global_position.y 
	
	var look_dir = (look_target_pos - ideal_eye_pos).normalized()
	
	var target_pitch = asin(look_dir.y) 
	var target_yaw = atan2(-look_dir.x, -look_dir.z)
	
	var current_yaw = cam_controller.input_rotation.y
	var delta_yaw = wrapf(target_yaw - current_yaw, -PI, PI)
	var final_yaw = current_yaw + delta_yaw
	
	tween.tween_property(cam_controller, "input_rotation:x", target_pitch, 0.5)
	tween.tween_property(cam_controller, "input_rotation:y", final_yaw, 0.5)
	
	await tween.finished
	tween.kill()
	cam_controller.input_rotation.x = target_pitch
	cam_controller.input_rotation.y = final_yaw
	
	if cutscene_eyes:
		cam_controller.set_cutscene_mode(cutscene_eyes)
	
	$AnimationTree.set("parameters/InteractShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if box_anim: box_anim.play("open")
	
	await get_tree().create_timer(2.0).timeout
	
	if ui_marker:
		cam_controller.set_cutscene_mode(ui_marker)
		GState.compute()
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		cam_controller.reset_camera_mode() 
		arm_ik.start()
		GState.play()

func quit_briefcase_sequence():
	cam_controller.reset_camera_mode()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	arm_ik.start()
	arm_ik.interpolation = 0.0
	var ik_tween = create_tween()
	ik_tween.tween_property(arm_ik, "interpolation", 1.0, 0.5)
	
	GState.game_state = GState.gstate_enum.PLAYING
