@tool
extends EditorPlugin

var inspector_plugin

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	inspector_plugin = preload("res://addons/viewportbaker/img_bake_ui.gd").new()
	add_inspector_plugin(inspector_plugin)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_inspector_plugin(inspector_plugin)
