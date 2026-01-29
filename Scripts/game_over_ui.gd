extends Control

@onready var menu_btn: Button = $Button
@onready var ship_le: LineEdit = $VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/LineEdit
@onready var rp_le: LineEdit = $VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer2/LineEdit
@onready var total_le: LineEdit = $VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer3/LineEdit

func _ready() -> void:
	visible = false
	Watcher.game_state_changed.connect(func():
		visible = GState.is_over()
		if GState.is_over():
			ship_le.text = "%s"%Watcher.ship_point
			rp_le.text = "%s"%Watcher.repair_point
			total_le.text = "%s"%(Watcher.repair_point+Watcher.ship_point)
		)
	menu_btn.pressed.connect(Watcher.change_scene.bind("res://main_menu.tscn"))
	
