extends HBoxContainer

func _ready() -> void:
	Watcher.game_state_changed.connect(func():
		visible = GState.is_idling()
		)

func add_slot():
	var cell_size = Vector2(60, 60)
	var slot:Control = Control.new()
	slot.custom_minimum_size = cell_size
	var c_panel:PanelContainer = PanelContainer.new()
	c_panel.custom_minimum_size = cell_size
	var item_txture:TextureRect = TextureRect.new()
	item_txture.custom_minimum_size = cell_size
	item_txture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	

func set_slot(idx:int, item:Item):
	pass
