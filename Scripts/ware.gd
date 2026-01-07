extends Control

@onready var i_con: Control = $VBoxContainer/PanelContainer2/VScrollBar/VBoxContainer

func _ready() -> void:
	for i in i_con.get_children(): i.queue_free()
	Watcher.game_state_changed.connect(func(a):
		if a == GState.gstate_enum.WARE:
			show()
		else: hide()
		)
	add_ui_item("res://Images/straight_pipe.png", "Wires")
	add_ui_item("res://Images/junction(activated).jpg", "Routers")

func add_ui_item(png:StringName, iname:String):
	var hbox := HBoxContainer.new()
	var panel_con:= PanelContainer.new()
	var texture:TextureRect = TextureRect.new()
	panel_con.custom_minimum_size = Vector2(100, 100)
	texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture.texture = load(png)
	var label:Label = Label.new()
	label.text = iname
	panel_con.add_child(texture)
	hbox.add_child(panel_con)
	hbox.add_child(label)
	i_con.add_child(hbox)
