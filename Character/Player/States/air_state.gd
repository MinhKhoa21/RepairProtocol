extends CharacterState
class_name AirState

@export var affected_by_gravity:bool = true
var is_falling:bool = true
@export var can_default:bool = true

func _setup() -> void:
	super()
	if can_default: limbo.add_transition(self, limbo.air_default, LimboNames.air_default)

func _update(delta: float) -> void:
	super(delta)
	is_falling = character.velocity.y < 0
	limbo.is_falling = is_falling
	if affected_by_gravity:
		character.velocity += character.get_gravity()

func check_dispatch():
	if character.is_on_floor(): dispatch(LimboNames.ground_default)

func dispatch_default(): dispatch(LimboNames.air_default)
