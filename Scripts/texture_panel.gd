extends Control
class_name CPanel

@export var custom_size:Vector2 = Vector2(64, 64):
	set = set_size_
@export var texture:Texture:
	set = set_texture

func _ready() -> void:
	custom_minimum_size = custom_size
	$TextureRect.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)

func set_texture(_text):
	texture = _text
	$TextureRect.texture = _text

func set_size_(_size):
	custom_size = _size
	pivot_offset = _size/2
