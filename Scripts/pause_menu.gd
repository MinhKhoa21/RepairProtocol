extends Control

@onready var leave_game: Button = $VBoxContainer/LeaveGame
@onready var settings: Button = $VBoxContainer/Settings

func _ready() -> void:
	Watcher.game_state_changed.connect(func(a):
		if a == GState.gstate_enum.PAUSED && Watcher.current_root == "garage":
			show()
		else:
			hide()
		)
	leave_game.pressed.connect(Watcher.change_scene.bind("res://main_menu.tscn"))
	
		
		
