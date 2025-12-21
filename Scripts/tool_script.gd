@tool
extends EditorScript

const LEFT = 8
const TOP = 4
const RIGHT = 2
const BOTTOM = 1

func _run() -> void:
	print(0b0101^0b0000)
	print((0b1111^0b1011)==~0b1011)

func get_one_selected() -> Node:
	return get_editor_interface().get_selection().get_selected_nodes()[0]
