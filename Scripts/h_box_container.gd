extends HBoxContainer

func _process(delta: float) -> void:
	visible = GState.is_playing()
	if visible: draw_hands()

func draw_hands():
	for i in HotBar.hands:
		var main_text_rect:TextureRect = (get_child(i).get_child(0) as TextureRect)
		var selected_text_rect:TextureRect = get_child(i).get_child(1)
		if HotBar.slots[i] == null || !HotBar.slots[i].item_texture: main_text_rect.texture = $None.get_texture()
		else: main_text_rect.texture = HotBar.slots[i].item_texture
		selected_text_rect.visible = i == HotBar.active_idx
