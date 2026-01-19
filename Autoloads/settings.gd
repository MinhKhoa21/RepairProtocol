extends Control

@onready var back: Button = $PanelContainer/Back
@onready var show_seconds_box: CheckButton = $PanelContainer/VBoxContainer/ShowSeconds/CheckButton

var show_seconds:bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	show_seconds_box.toggled.connect(func(x): show_seconds = x)
	Watcher.game_state_changed.connect(func():
		if GState.is_settings(): show()
		else: hide()
		)
	back.pressed.connect(Watcher.back.emit)
