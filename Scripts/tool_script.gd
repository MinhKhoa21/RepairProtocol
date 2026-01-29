@tool
extends EditorScript

func _run() -> void:
	print(get_one_selected_3D().transform)

func get_one_selected() -> Node:
	return EditorInterface.get_selection().get_selected_nodes()[0]

func get_one_selected_3D() -> Node3D:
	return EditorInterface.get_selection().get_selected_nodes().filter(func(x): return x is Node3D)[0]
