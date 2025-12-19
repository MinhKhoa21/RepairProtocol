extends MouseControl
class_name StackedPanel

@onready var template: PanelContainer = $PanelContainer

func _ready() -> void:
	super()
	template.size = custom_minimum_size

func add_texture(_text:Texture, _rot:float = 0, _size:Vector2 = Vector2(64, 64)):
	var c_panel:CPanel = load("res://Scenes/c_panel.tscn").instantiate()
	c_panel.texture = _text
	c_panel.rotation += deg_to_rad(_rot)
	custom_minimum_size = _size
	c_panel.custom_size = custom_minimum_size
	c_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(c_panel)
	if template && template.visible: template.visible = false
