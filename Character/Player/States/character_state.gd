@abstract
extends LimboState
class_name CharacterState

@export var can_dispatch_to:Dictionary[String, CharacterState]
@export var ani_kit:AniKit
@export var use_default_ani:bool = true
var limbo:CLimboHSM
var character:Character
var ani:AnimationPlayer

func _setup() -> void:
	limbo = get_parent()
	character = limbo.character
	ani = character.ani
	for i in can_dispatch_to.keys():
		limbo.add_transition(self, can_dispatch_to[i], i)

func _enter() -> void:
	print("entered state ", self.name)
	if use_default_ani: ani_kit.play(ani)

func _update(delta: float) -> void:
	check_dispatch()

func check_dispatch(): pass
