extends Camera3D
class_name FPSCam

@export var fixed_cam:bool = false
@export var pan_limit_x:Vector2 = Vector2(0, 0)
@export var pan_limit_y:Vector2 = Vector2(-89, 90)
var mouse_sensitivity:float = 0.003
var pitch_y:float = 0
var pitch_x:float = 0

#@export var fixed_pos:bool = false
#@export var par_node:Node3D
var offset:Vector3

func _input(event: InputEvent) -> void:
	if !current: return
	if event is InputEventMouseMotion && (GState.is_playing() || GState.is_inspecting()):
		pitch_x -= event.relative.x*mouse_sensitivity
		pitch_y -= event.relative.y*mouse_sensitivity
		if pan_limit_x != Vector2(0, 0): pitch_x = clampf(pitch_x, deg_to_rad(pan_limit_x.x), deg_to_rad(pan_limit_x.y))
		pitch_y = clampf(pitch_y, deg_to_rad(pan_limit_y.x), deg_to_rad(pan_limit_y.y))
		#rotation.x = pitch_y
		#rotation.y -= event.relative.x * mouse_sensitivity
		#get_parent().rotation.x -= event.relative.y * mouse_sensitivity
		#get_parent().rotation.y -= event.relative.x * mouse_sensitivity
		get_parent().global_rotation.x = pitch_y
		get_parent().global_rotation.y = pitch_x

#func _ready() -> void:
	#offset = position

#func _process(delta: float) -> void:
	#if fixed_pos:
		#top_level = true
		#global_position = par_node.global_position + offset
		#global_rotation.y = par_node.global_rotation.y

func get_forward() -> Vector3:
	var dir = -global_transform.basis.z
	dir.y = 0
	return dir.normalized()

func get_right() -> Vector3:
	var dir = global_transform.basis.x
	dir.y = 0
	return dir.normalized()
