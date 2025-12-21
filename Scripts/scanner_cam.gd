extends Camera3D

func _process(delta: float) -> void:
	if Watcher.player_cam:
		var cam = Watcher.player_cam
		global_transform = cam.global_transform
