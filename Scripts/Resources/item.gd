extends Resource
class_name Item

enum item_enum {
	HAMMER,
	SCREWDRIVER,
	PIPE_L,
	PIPE_I,
}

@export var item_type:item_enum = item_enum.HAMMER
@export var item_texture:Texture2D
@export var item_name:StringName
@export var stackable:bool = false
@export var max_stack:int = 1:
	set(val): max_stack = val if stackable else 1
@export var quantity:int = 1:
	set(val): quantity = clampi(val, 0, max_stack)

@export var manifest_path:StringName = ""
@export var one_shot_name:StringName = ""
