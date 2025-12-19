extends GroundState

var duration:float = 1


func _enter() -> void:
	super()
	duration = assign_duration()
	fire_one_shot(Watcher.cargo[0])

func _update(delta: float) -> void:
	if duration <= 0:
		character.hit = false
		dispatch_default()
	duration -= delta

func assign_duration() -> float:
	if limbo.tool_hit: return AniTimes.time_from_name[limbo.tool_action]
	elif limbo.interact: return AniTimes.time_from_name[limbo.interact_action]
	return 1

func fire_one_shot(one_shot_name:StringName):
	limbo.ani_tree.set("parameters/Hand/HandAction/%s/request"%[one_shot_name], AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
