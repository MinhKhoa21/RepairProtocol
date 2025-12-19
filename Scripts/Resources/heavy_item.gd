extends RigidBody3D
class_name HeavyItem

@export var holding_Sprite:MeshInstance3D
@export var sprite:MeshInstance3D
@export var i_area:InteractArea
#var offset:Vector3
var is_holding:bool = false:
	set(val):
		if val && !is_holding:
			scale = Vector3(1, 1, 1)*0.5
			HotBar.select(-2)
		is_holding = val
var disabled:bool = true:
	set(val):
		if !val && disabled: scale = Vector3(1, 1, 1)*1.5
		disabled = val

func _ready() -> void:
	#offset = holding_point.position
	i_area.interacted.connect(func():
		if disabled: return
		pick_up()
		)

func _process(delta: float) -> void:
	if disabled:
		return
	if is_holding:
		freeze = true
		global_position = Watcher.right_hand.global_position
		global_rotation = Watcher.right_hand.global_rotation + Vector3(0, deg_to_rad(90), 0)
	holding_Sprite.visible = is_holding
	sprite.visible = !holding_Sprite.visible


func pick_up():
	if is_holding: return
	is_holding = true
