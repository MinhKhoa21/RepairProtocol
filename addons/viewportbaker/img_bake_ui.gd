extends EditorInspectorPlugin

func _can_handle(object: Object) -> bool:
	return object is SubViewport

func _parse_end(object: Object) -> void:
	var vp:SubViewport = object as SubViewport
	var ledit:LineEdit = LineEdit.new()
	ledit.placeholder_text = "Image name here"
	var btn:Button = Button.new()
	btn.text = "Bake Image"
	btn.pressed.connect(func():
		btn.text = "Baking..."
		btn.disabled = true
		ledit.queue_redraw()
		await bake_viewport(vp, ledit.text)
		btn.text = "Bake Image"
		btn.disabled = false
		)
	var hbox:HBoxContainer = HBoxContainer.new()
	hbox.custom_minimum_size = Vector2(40, 40)
	hbox.add_child(ledit)
	hbox.add_child(btn)
	add_custom_control(hbox)

func bake_viewport(vp, file_name):
	#var selected_nodes = EditorInterface.get_selection().get_selected_nodes()
	
	# Safety check: is the selection empty?
	#if selected_nodes.is_empty():
		#print("Select something first, you dumbass.") # Keeping your energy
		#return
		
	#var vp = selected_nodes[0]
	if not vp is SubViewport:
		print("Thats not a sub viewport.")
		return

	var dir_path = "res://Images/EditorBaked/"
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)

	#Construct a full FILE path (Folder + Name + Extension)
	var save_path = dir_path + file_name + ".png"

	#vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	# Small trick: In the editor, sometimes you need to wait a frame 
	# for the GPU to actually fill the buffer after changing update_mode.
	# If your images come out black, uncomment the line below:
	# await get_tree().process_frame 

	var img: Image = vp.get_texture().get_image()
	
	var err = img.save_png(save_path)
	
	if err == OK:
		print("Bake successful: ", save_path)
		EditorInterface.get_resource_filesystem().scan()
	else:
		push_error("Failed to save bake! Error code: ", err)
	
	#vp.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
