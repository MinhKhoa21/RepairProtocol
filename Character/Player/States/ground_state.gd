extends CharacterState
class_name GroundState

var is_moving:bool = false
@export var can_default:bool = true

func _setup() -> void:
	super()
	if can_default: limbo.add_transition(self, limbo.ground_default, LimboNames.ground_default)

func _update(delta: float) -> void:
	super(delta)
	#fall()
	is_moving = !(blackboard.get_var(BBNames.direction) as Vector3).is_zero_approx()
	limbo.is_moving = is_moving

func check_dispatch():
	if !character.is_on_floor(): dispatch(LimboNames.air_default)

func dispatch_default(): dispatch(LimboNames.ground_default)
