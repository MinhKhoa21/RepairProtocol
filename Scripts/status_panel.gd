extends Control

@onready var ship_holder: Node3D = $ShipUI/SubViewport/ShipHolder
@onready var ship_ui: SubViewportContainer = $ShipUI

var mouse_down:bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	visible = GState.is_checking()

func _on_ship_ui_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && mouse_down:
		var mouse_relative:Vector2 = (event as InputEventMouseMotion).relative * 0.02
		ship_holder.rotation += Vector3(mouse_relative.y, mouse_relative.x, 0)

func has_mouse(_control:Control) -> bool:
	return _control.get_global_rect().has_point(get_global_mouse_position())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() && has_mouse(ship_ui): mouse_down = true
		elif event.is_released(): mouse_down = false
