extends Resource
class_name Item

@export var item_texture:Texture2D
@export var item_name:StringName
@export var stackable:bool = false
@export var max_stack:int = 1:
	set(val): max_stack = val if stackable else 1
@export var quantity:int = 1:
	set(val): quantity = clampi(val, 0, max_stack)

@export var manifest_path:StringName = ""
@export var one_shot_name:StringName = ""

func _init(_item_name:StringName = "", _stackable:bool = false, _max_stack:int = 1, _quantity:int = 1) -> void:
	item_name = _item_name
	stackable = _stackable
	if stackable:
		max_stack = _max_stack
		quantity = _quantity
