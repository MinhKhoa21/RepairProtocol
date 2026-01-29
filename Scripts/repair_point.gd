extends InteractArea
class_name RepairPoint

@export var cam:Camera3D
@export var highlight_meshes:Array[MeshInstance3D]
@export var puzzles:Array[StringName]
@export var puzzle_template:Dictionary[Puzzle.type, Node3D]
@export var openers:Array
var puzzle:Puzzle
var damaged:bool = false
var severity:int = 0
var scanned:bool = false

func _ready() -> void:
	ColKit.set_interact(self, false)
	ColKit.set_scan(self, true)
	interacted.connect(func():
		if puzzle.puzzle_type == Puzzle.type.pipe && !HotBar.is_hammer(): return
		if puzzle.puzzle_type == Puzzle.type.panel && !HotBar.is_screwdriver(): return
		var player = Watcher.player
		var tween = create_tween()
		tween.tween_property(player, "global_position", Vector3(cam.global_position.x, player.global_position.y, cam.global_position.z), 0.5)
		tween.parallel().tween_property(player.cam_controller, "global_rotation", cam.global_rotation, 0.5)
		await  tween.finished
		tween.kill()
		player.cam_controller.set_cutscene_mode(cam)
		)
	Watcher.game_state_changed.connect(func():
		if !GState.is_solving() && Watcher.player: Watcher.player.cam_controller.reset_camera_mode()
		)

func set_damaged_and_unscanned():
	scanned = false
	damaged = true
	severity = [1, 2].pick_random()

func repair():
	severity -= 1
	if severity <= 0:
		damaged = false
		ColKit.set_interact(self, false)
		GState.idle()
	else:
		puzzle.create_puzzle.emit()
	Watcher.repaired.emit(self)

func set_puzzle():
	pass
