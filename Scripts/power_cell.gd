extends HeavyItem
class_name PowerCell

func _ready() -> void:
	super()
	freeze = true
	disabled = true
	i_area.interacted.connect(extract, CONNECT_ONE_SHOT)

func extract():
	#$SnapPoint.snap(Watcher.player, Watcher.player.neck, true)
	#await $SnapPoint.snapped
	Watcher.cargo = ["ExtractPowerCell"]
	Watcher.player.hit = true
	Watcher.player.hand_snap($MovingPart/Marker.global_transform)
	var tim:Timer = TimerKit.generate_timer(AniTimes.take_powercell_start, func(): return)
	add_child(tim)
	await tim.timeout
	$AnimationPlayer.play("extract", -1, MathKit.stretch($AnimationPlayer.get_animation("extract").length, AniTimes.take_powercell_short_full-AniTimes.take_powercell_start)*AniTimes.take_powercell_speed)
	#$AnimationPlayer.play("extract", -1, 0.33)
	$AnimationPlayer.animation_changed.connect(func(a, b):
		Watcher.player.hand_snap_back()
		relocate()
		, CONNECT_ONE_SHOT)
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.queue("RESET")
	disabled = false
	freeze = false
	#i_area.interacted.emit()

func reconnect():
	i_area.interacted.connect(extract, CONNECT_ONE_SHOT)

func relocate():
	global_position = $MovingPart/Marker.global_position
