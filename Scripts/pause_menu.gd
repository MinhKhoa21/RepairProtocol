extends Control

@onready var leave_game: Button = $VBoxContainer/LeaveGame
@onready var settings: Button = $VBoxContainer/Settings
@onready var back: Button = $VBoxContainer/Back

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Watcher.game_state_changed.connect(func():
		if GState.is_paused() && Watcher.current_root == Watcher.root_enum.GARAGE:
			show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			hide()
		)
	leave_game.pressed.connect(Watcher.change_scene.bind("res://main_menu.tscn"))
	settings.pressed.connect(GState.settings)
	back.pressed.connect(Watcher.back.emit)
		
