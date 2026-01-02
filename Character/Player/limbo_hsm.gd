extends LimboHSM
class_name CLimboHSM

var character:Character
var is_moving:bool = false
var is_falling:bool = false
var hit:bool = false
@export var ground_default:GroundState
@export var air_default:AirState
@onready var ani_tree: AnimationTree = $"../AnimationTree"
var is_holding:bool = true
var interact:bool = false
var tool_hit:bool = false
var tool_action:StringName = ""
var interact_action:StringName = ""
var can_run:bool = false

func _ready() -> void:
	character = get_parent()
	CharBB.generate_bb(CharBB.char_type.PLAYER, blackboard)
	initialize(character)
	#Watcher.hand_swapped.connect(func(): tool_hit = false)
	#add_child(TimerKit.generate_timer(1, func(): is_holding = !is_holding, false))

func _update(delta: float) -> void:
	tool_action = HotBar.active_name
	if !Watcher.cargo.is_empty() && Watcher.cargo[0] is String: interact_action = Watcher.cargo[0]
	is_holding = HotBar.active_idx != -1
	tool_hit = (character as Player).hit && HotBar.active_idx >= 0
