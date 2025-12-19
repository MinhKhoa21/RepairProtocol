extends GroundState

#@export var idle_ani:AniKit
#@export var walk_ani:AniKit

func _update(delta: float) -> void:
	super(delta)
	#if is_moving: walk_ani.play(ani)
	#else: idle_ani.play(ani)

func check_dispatch():
	super()
	if limbo.tool_hit || limbo.interact: dispatch("ground_action")
