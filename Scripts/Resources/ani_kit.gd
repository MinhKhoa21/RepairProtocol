extends Resource
class_name AniKit

@export var ani_name:StringName
@export var blend:float = -1
@export var speed:float = 1
@export var from_end:bool = false

func play(ani:AnimationPlayer):
	if ani_name == "": return
	ani.play(ani_name, blend, speed, from_end)
