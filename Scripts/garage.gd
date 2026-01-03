extends Level

@export_group("Setup")
@export var ship_root: Node3D
@export var destination_point: Node3D
@export var landing_duration: float = 8.0
@export var brake_time: float = 2.0
var ground_smokes: Array[GPUParticles3D] = []
var ship_spawn_point:Transform3D

func _ready() -> void:
	Watcher.garage = self
	ship_spawn_point = ship_root.global_transform
	GState.play()
	var found = destination_point.find_children("*", "GPUParticles3D", true, false)
	for p in found:
		if p.name.to_lower().contains("smoke"):
			ground_smokes.append(p)
			p.emitting = false # Tắt lúc đầu
			
	#perform_landing()

func perform_landing():
	ship_root.global_transform = ship_spawn_point
	for i in ship_root.get_children(): i.queue_free()
	ship_root.add_child(Watcher.current_ship)
	var ship_leg = ship_root.get_child(0).get_node("LandingPoint")
	var offset_vector = ship_root.global_position - ship_leg.global_position
	var final_pos = destination_point.global_position + offset_vector
	var target_rot = destination_point.global_rotation
	
	play_push_anims()
	
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(ship_root, "global_position", final_pos, landing_duration)
	tween.parallel().tween_property(ship_root, "global_rotation", target_rot, landing_duration)
	
	var time_to_start_brake = landing_duration - brake_time
	if time_to_start_brake < 0: time_to_start_brake = 0 
	
	tween.parallel().tween_callback(play_brake_anims).set_delay(time_to_start_brake)
	
	var smoke_stop_delay = time_to_start_brake + (brake_time * 0.5) 
	tween.parallel().tween_callback(stop_ground_smoke).set_delay(smoke_stop_delay)
	
	tween.chain().tween_callback(reset_anims)

func stop_ground_smoke():
	for p in ground_smokes:
		p.emitting = false
	Watcher.cargo.clear()
	Watcher.cargo.append({"ship_hologram":ship_root.get_child(0)})

func play_push_anims():
	if "thrusters" in ship_root.get_child(0):
		for t in ship_root.get_child(0).thrusters:
			if t is MeshInstance3D:
				t.visible = true

func play_brake_anims():
	if "thrusters" in ship_root.get_child(0):
		for t in ship_root.get_child(0).thrusters:
			if "brake" in t.name.to_lower():
				t.visible = true
	
	for p in ground_smokes:
		p.emitting = true
func reset_anims():
	if "thrusters" in ship_root.get_child(0):
		for t in ship_root.get_child(0).thrusters:
			t.visible = false
			
	print("Landed")
