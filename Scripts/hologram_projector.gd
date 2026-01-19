extends Node3D
class_name HologramProjector

#@export var hologram_shader:ShaderMaterial
@export var stand_look_point:Array[Node3D]
@export var hologram_scale:Dictionary[StringName, float]
@onready var hologram: Node3D = $Hologram
@onready var sub_viewport: SubViewport = $Request/Sprite3D/SubViewport
@onready var request: Node3D = $Request
@onready var request_ui: Control = $Request/Sprite3D/SubViewport/RequestUi
@onready var interact_area: InteractArea = $InteractArea
@onready var sprite_3d: Sprite3D = $Request/Sprite3D
var meshes:Array[MeshInstance3D]
var ship_mesh
var ui:Control

func _ready() -> void:
	Watcher.hp = self
	hologram_cache()
	request_ui.close.pressed.connect(func():
		GState.idle()
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
		if !Watcher.current_ship: show_ui()
		else: hologram.visible = true
		)
	Watcher.game_state_changed.connect(func():
		if !GState.is_checking():
			if hologram.visible: hologram.rotation = Vector3.ZERO
			hide_ui()
			Watcher.player.cam_controller.reset_camera_mode()
		)
	Watcher.ship_changed.connect(func():
		if !Watcher.current_ship:
			show_hologram(false)
		else:
			show_hologram(true)
			assign_hologram(Watcher.current_hologram)
		)

#func _physics_process(delta: float) -> void:
	#var cur_ship_mesh
	#if Watcher.current_ship:
		#cur_ship_mesh = Watcher.current_ship.main_mesh
		#
	#if ship_mesh != cur_ship_mesh:
		#if cur_ship_mesh == null:
			#hologram.visible = false
			#request.visible = true
		#else:
			#hologram.visible = true
			#request.visible = false
			#hologram_cache()
			#var hologram_mesh = Watcher.current_hologram
			#hologram.add_child(hologram_mesh)
			#hologram_mesh.scale*=hologram_scale[ship_mesh]
			#project()

#func convert_hologram(arr:Array):
	#for i:MeshInstance3D in arr:
		#i.set_surface_override_material(0, hologram_shader)

#func project():
	##hologram_cache()
	#meshes = hologram.get_child(0).get_children(true).filter(func(x): return x is MeshInstance3D)
	#convert_hologram(meshes)
	#Watcher.current_hologram = meshes

func hologram_cache():
	for i in hologram.get_children(): i.queue_free()

func _input(event: InputEvent) -> void:
	
	if !hologram.visible: return
	#var pressed := false
	#if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed(): pressed = true
	#if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_released(): pressed = false
	if event is InputEventMouseMotion && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && GState.is_checking():
		var mouse_pan := (event as InputEventMouseMotion).screen_relative*0.01
		hologram.rotation+=Vector3(0, mouse_pan.x, -mouse_pan.y)
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

func show_hologram(_bool:bool):
	if _bool:
		view_request(false)
		hologram.visible = true
		request.visible = false
	else: #shows request
		hologram.visible = false
		request.visible = true

func view_request(_bool:bool):
	if _bool:
		show_ui()
	else:
		hide_ui()

func assign_hologram(ship_hologram:Node3D):
	for i in hologram.get_children(): i.queue_free()
	
	if ship_hologram:
		hologram.add_child(ship_hologram)
		hologram.scale = Vector3(1, 1, 1) * Watcher.current_ship_file.hologram_scale
	

#func queue_draw(cell):
	#pass
