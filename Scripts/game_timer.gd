extends CControl

@onready var time_label:Label = $PanelContainer/Label
@onready var timer: Timer = $Timer

func _ready() -> void:
	hide()
	Watcher.game_state_changed.connect(func():
		if GState.is_paused() || GState.is_idling(): ease_show(3, 0.5)
		else: ease_hide(1, 0.5)
		)
	

func _process(_d: float) -> void:
	time_label.text = Watcher.get_clock(Settings.show_seconds)
