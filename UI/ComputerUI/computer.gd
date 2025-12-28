extends Node3D
class_name Laptop

signal opened_sig
signal closed_sig

var opened:bool = false
var run:bool = false

@export var stand_pos: Marker3D
@export var ui_cam_pos: Marker3D

## Kiểm tra xem chuột có nằm trong Area3D không
var is_mouse_inside = false
## Vị trí sự kiện chuột 2D cuối cùng để tính toán chuyển động tương đối
var last_event_pos2D = null
## Thời gian của sự kiện cuối cùng
var last_event_time: float = -1.0

@onready var node_viewport = $Computer/SubViewport
@onready var node_quad = $Computer/SciFiDeck/Case_Upper/Quad
@onready var node_area = $Computer/SciFiDeck/Screen/Area3D

func _ready():
	$InteractArea.interacted.connect(_on_interacted)
	
	node_area.mouse_entered.connect(_mouse_entered_area)
	node_area.mouse_exited.connect(_mouse_exited_area)
	node_area.input_event.connect(_mouse_input_event)

func _on_interacted():
	if $InteractArea.on_cd: return
	
	$InteractArea.on_cd = true
	add_child(TimerKit.generate_timer(AniTimes.open_case_full, func(): $InteractArea.on_cd = false))
	
	opened = !opened
	
	if opened:
		Watcher.player.sequence_open_briefcase(stand_pos.global_transform, self.global_position, null, ui_cam_pos)
		
		await get_tree().create_timer(0.5).timeout
		update_anim_tree()
		opened_sig.emit()
		
		
	else:
		Watcher.player.quit_briefcase_sequence()
		
		update_anim_tree()
		closed_sig.emit()
		
		
		is_mouse_inside = false
		last_event_pos2D = null

func update_anim_tree():
	var playback = $AnimationTree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	playback.travel("Start")
	
	$AnimationTree.set("parameters/conditions/open", opened)
	$AnimationTree.set("parameters/conditions/close", !opened)


func _mouse_entered_area():
	if !opened: return
	is_mouse_inside = true

func _mouse_exited_area():
	is_mouse_inside = false

func _unhandled_input(event):
	if !opened: return 
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("interact"):
		_on_interacted()
		get_viewport().set_input_as_handled()
		return
	
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			return
	node_viewport.push_input(event)

func _mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
	if !opened: return
	

	var quad_mesh_size = node_quad.mesh.size
	var event_pos3D = event_position
	var now: float = Time.get_ticks_msec() / 1000.0

	event_pos3D = node_quad.global_transform.affine_inverse() * event_pos3D

	var event_pos2D: Vector2 = Vector2()

	if is_mouse_inside:
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)
		event_pos2D.x = event_pos2D.x / quad_mesh_size.x
		event_pos2D.y = event_pos2D.y / quad_mesh_size.y
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5
		event_pos2D.x *= node_viewport.size.x
		event_pos2D.y *= node_viewport.size.y

	elif last_event_pos2D != null:
		event_pos2D = last_event_pos2D

	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D
	
	if event is InputEventMouseButton and event.pressed:
		print("Click 3D tại: ", event_position)
		print("Đổi sang 2D Viewport tại: ", event_pos2D)
		print("Kích thước Viewport: ", node_viewport.size)

	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		else:
			event.relative = event_pos2D - last_event_pos2D
			if now - last_event_time > 0:
				event.velocity = event.relative / (now - last_event_time)

	last_event_pos2D = event_pos2D
	last_event_time = now

	node_viewport.push_input(event)
