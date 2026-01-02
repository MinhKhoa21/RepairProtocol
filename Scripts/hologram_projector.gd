extends Node3D

@export var hologram_shader:ShaderMaterial
@export var stand_look_point:Array[Node3D]
@onready var hologram: Node3D = $Hologram
@onready var sub_viewport: SubViewport = $Request/Sprite3D/SubViewport
@onready var request: Node3D = $Request
@onready var request_ui: Control = $Request/Sprite3D/SubViewport/RequestUi
@onready var interact_area: InteractArea = $InteractArea
@onready var sprite_3d: Sprite3D = $Request/Sprite3D
var meshes:Array
var ship_mesh
var ui:Control

func _ready() -> void:
	hologram_cache()
	request_ui.close.pressed.connect(func():
		GState.play()
		)
	interact_area.interacted.connect(func():
		var player = Watcher.player
		var tween:= create_tween()
		tween.tween_property(player, "global_position", stand_look_point[0].global_position*Vector3(1, 0, 1)+Vector3(0, player.global_position.y, 0), 0.2)
		tween.parallel().tween_property(player.cam_controller, "global_rotation", stand_look_point[1].global_rotation, 0.2)
		await tween.finished
		tween.kill()
		#player.cam_controller.look_at(stand_look_point[1].global_position)
		player.cam_controller.set_cutscene_mode(stand_look_point[1])
		GState.check()
		#show_ui(preload("res://Scenes/request_ui.tscn").instantiate())\
		show_ui()
		)
	Watcher.game_state_changed.connect(func(a):
		if a != GState.gstate_enum.CHECKING:
			hide_ui()
			Watcher.player.cam_controller.reset_camera_mode()
		)

func _physics_process(delta: float) -> void:
	var cur_ship_mesh
	if Watcher.current_ship:
		cur_ship_mesh = Watcher.current_ship.main_mesh
	else: cur_ship_mesh = null
	request.visible = true
	if ship_mesh != cur_ship_mesh:
		if cur_ship_mesh == null:
			hologram.visible = false
			request.visible = true
		else:
			hologram.visible = true
			request.visible = false
			ship_mesh = cur_ship_mesh
			hologram_cache()
			hologram.add_child(load(ship_mesh).instantiate())
			project()

func convert_hologram(arr:Array):
	#var mat := ShaderMaterial.new()
	#mat.shader = preload("res://ShaderMaterial/ship_ui.gdshader")
	
	for i:MeshInstance3D in arr:
		i.set_surface_override_material(0, hologram_shader)

func project():
	#hologram_cache()
	meshes = hologram.get_child(0).get_children(true).filter(func(x): return x is MeshInstance3D)
	convert_hologram(meshes)

func hologram_cache():
	for i in hologram.get_children(): i.queue_free()

#func _input(event: InputEvent) -> void:
	#if !(event is InputEventMouseButton && (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT && event.is_pressed() && GState.is_checking()): return
	#var vp := get_viewport()
	#var mouse_pos := vp.get_mouse_position()
	#var cam := vp.get_camera_3d()
	#var from := cam.project_ray_origin(mouse_pos)
	#var dir := cam.project_ray_normal(mouse_pos)
	#var to := from + dir*(cam.far if cam.far > 0 else 100000.0)
	#var query := PhysicsRayQueryParameters3D.create(from, to)
	#var result = get_world_3d().direct_space_state.intersect_ray(query)
	#print(result)

#func create_ui():
	#var shown_ui:Control = request_ui.duplicate()
	#var scale_offset = global_transform.basis.x.length()
	#Watcher.player.add_child(shown_ui)
	#shown_ui.scale /= Vector2(1, 1)*scale_offset
	#shown_ui.scale *= 0.9
	#shown_ui.position = get_viewport().get_visible_rect().get_center()-shown_ui.get_global_rect().size/2
	#ui = shown_ui
	#ui.hide()

func show_ui():
	var scale_offset = global_transform.basis.x.length()
	request_ui.reparent(Watcher.player)
	request_ui.scale /= Vector2(1, 1)*scale_offset
	request_ui.scale *= 0.9
	request_ui.position = get_viewport().get_visible_rect().get_center()-request_ui.get_global_rect().size/2
	sprite_3d.visible = false

func hide_ui():
	request_ui.reparent(sub_viewport)
	request_ui.scale = Vector2(1, 1)
	request_ui.position = Vector2.ZERO
	sprite_3d.visible = true
