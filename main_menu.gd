extends Level

@onready var start: Button = $Control/PanelContainer/VBoxContainer/Start
@onready var settings: Button = $Control/PanelContainer/VBoxContainer/Settings
@onready var exit: Button = $Control/PanelContainer/VBoxContainer/Exit
var opacity:float = 0:
	set = set_opacity
func set_opacity(a):
	$Camera3D/MeshInstance3D.material_override.albedo_color += Color(0, 0, 0, a)

func _ready() -> void:
	$Control.visible = true
	opacity = 0
	GState.pause()
	var cam_pan = func():
		print("bleh!")
		var _tween:Tween = create_tween()
		var cam:Node3D = $Camera3D
		_tween.tween_property(cam, "global_rotation", $Camera3D.global_rotation+Vector3(0, deg_to_rad(90), 0), 5)
		await _tween.finished
		_tween.kill()
	add_child(TimerKit.generate_timer(randf_range(7.0, 8.5), cam_pan, false))
	cam_pan.call()
	start.pressed.connect(func():
		$Control.visible = false
		var _tween := create_tween()
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0, 0, 0, 1)
		_tween.tween_property(self, "opacity", 1, 2)
		await _tween.finished
		_tween.kill()
		#alpha.material_override = mat
		#await get_tree().create_timer(1).timeout
		Watcher.change_scene("res://Level/level.tscn")
		)
