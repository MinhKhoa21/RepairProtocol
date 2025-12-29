extends Node

var target_scene:StringName

func _ready() -> void:
	target_scene = Watcher.queued_scene
	ResourceLoader.load_threaded_request(target_scene)

func _process(_delta):
	var progress := []
	var status = ResourceLoader.load_threaded_get_status(
		target_scene,
		progress
	)

	if progress.size() > 0:
		$ProgressBar.value = progress[0] * 100

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed_scene = ResourceLoader.load_threaded_get(target_scene)
		get_tree().change_scene_to_packed(packed_scene)
