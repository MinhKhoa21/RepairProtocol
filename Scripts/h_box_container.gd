extends HBoxContainer

func _ready() -> void:
	Watcher.game_state_changed.connect(func():
		visible = GState.is_idling()
		)
	for i in range(HotBar.hands): add_slot()
	Watcher.hotbar_populated.connect(func():
		for i in HotBar.slots.size():
			set_slot(i, HotBar.slots[i])
		)
	Watcher.hand_swapped.connect(func(_a):
		for i in range(HotBar.hands):
			var slot_panel = get_child(i).get_child(0) as PanelContainer
			var style_box = StyleBoxFlat.new()
			if i == _a: style_box.bg_color = Color(1, 1, 1, 0.5)
			else: style_box.bg_color = Color(0, 0, 0, 0.5)
			slot_panel.remove_theme_stylebox_override("normal")
			slot_panel.add_theme_stylebox_override("normal", style_box)
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
	item_txture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	item_txture.texture = preload("res://Images/EditorBaked/empty_slot.png")
	
	slot.add_child(c_panel)
	slot.add_child(item_txture)
	add_child(slot)

func set_slot(idx:int, item:Item):
	var slot:Control = get_child(idx)
	var slot_text:TextureRect = slot.get_child(1) as TextureRect
	if item == null || item.item_texture == null: slot_text.texture = preload("res://Images/EditorBaked/empty_slot.png")
	else:
		slot_text.texture = item.item_texture
		
