extends CanvasLayer

@export var main_camera: Camera3D 

@onready var hud_wrapper = $ColorRect 
@onready var screen_container = $ColorRect/ScreenContainer 
@onready var sub_viewport = $ColorRect/ScreenContainer/SubViewport
@onready var scanning_camera = %CyberEyes 

func _ready():
	if not main_camera:
		main_camera = get_viewport().get_camera_3d()
	if sub_viewport:
		sub_viewport.world_3d = get_viewport().world_3d
	if hud_wrapper:
		hud_wrapper.visible = false 
		hud_wrapper.mouse_filter = Control.MOUSE_FILTER_IGNORE

	set_param(0.0, "visibility")
	set_param(0.0, "scanning_progress")

func _process(delta: float) -> void:
	if main_camera and scanning_camera:
		scanning_camera.global_transform = main_camera.global_transform

		scanning_camera.fov = main_camera.fov
		

func toggle_scan(is_scanning: bool):
	var tween = create_tween()
	
	if is_scanning:
		if hud_wrapper: 
			hud_wrapper.visible = true
		
		set_param(0.0, "scanning_progress")
		tween.tween_method(set_param.bind("visibility"), 0.0, 1.0, 0.2)
		tween.parallel().tween_method(set_param.bind("scanning_progress"), 0.0, 1.0, 1.2)
		
	else:
		tween.tween_method(set_param.bind("visibility"), 1.0, 0.0, 0.2)
		
		tween.tween_callback(func(): 
			if hud_wrapper: 
				hud_wrapper.visible = false
		)
	tween.finished.connect(tween.kill)

func set_param(value, param_name):
	if screen_container and screen_container.material:
		screen_container.material.set_shader_parameter(param_name, value)

func get_param(param_name):
	if screen_container and screen_container.material:
		return screen_container.material.get_shader_parameter(param_name)
	return 0.0
