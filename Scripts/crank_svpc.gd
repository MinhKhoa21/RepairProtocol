extends Control

@export var vertical:bool = false
@export var flip:bool = false

@onready var color_rect: ColorRect = $ColorRect
@onready var mesh_instance: MeshInstance3D = $SubViewportContainer/SubViewport/MeshInstance3D
@onready var svpc: SubViewportContainer = $SubViewportContainer

var dragging:bool = false
var drag_offset:Vector2
var drag_threshold:Vector2
var flip_int:int = 1

func _ready() -> void:
	if flip: flip_int = -1
	if vertical:
		mesh_instance.rotation.z += deg_to_rad(90)
	if !vertical: drag_threshold = Vector2(color_rect.position.x, color_rect.position.x+color_rect.size.x)
	else: drag_threshold = Vector2(color_rect.position.y, color_rect.position.y+color_rect.size.y)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			dragging = true
			drag_offset = event.position
		elif !event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			dragging = false
	
	if event is InputEventMouseMotion && dragging:
		if !vertical:
			svpc.position += event.relative * Vector2(1, 0)
			svpc.position.x = clampf(svpc.position.x, drag_threshold.x, drag_threshold.y)
		else:
			svpc.position += event.relative * Vector2(0, 1)
			svpc.position.y = clampf(svpc.position.y, drag_threshold.x, drag_threshold.y)

func get_center_point(_node:Control):
	return Vector2(_node.size.x/2 + _node.position.x, _node.size.y/2 + _node.position.y)
