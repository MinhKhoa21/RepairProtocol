extends Node

const cp = "cmd"

@onready var pos_x: TextEdit = $Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer/XEdit
@onready var pos_y: TextEdit = $Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer/YEdit
@onready var pos_z: TextEdit = $Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer/ZEdit
@onready var rot_x: TextEdit = $Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer2/XEdit
@onready var rot_y: TextEdit = $Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer2/YEdit
@onready var rot_z: TextEdit = $Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer2/ZEdit


var stored_keys:String = "":
	set = set_keys
func set_keys(a):
	var tempt:String = stored_keys
	tempt += a
	if tempt.length() > 5: tempt = "".join(tempt.split("").slice(-5))
	if tempt.contains(cp):
		open_cmd()
		stored_keys = ""
		return
	stored_keys = tempt
var back:Array[Node]

var reset_text = func(text_edit:TextEdit):
	text_edit.text = ""
var selected_node:Node
var move = func():
	selected_node.global_position += Vector3(
		pos_x.text as float,
		pos_y.text as float,
		pos_z.text as float
	)
	reset_text.call(pos_x)
	reset_text.call(pos_y)
	reset_text.call(pos_z)
var spin = func():
	selected_node.global_rotation += Vector3(
		deg_to_rad(rot_x.text as float),
		deg_to_rad(rot_y.text as float),
		deg_to_rad(rot_z.text as float)
	)
	reset_text.call(rot_x)
	reset_text.call(rot_y)
	reset_text.call(rot_z)

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_pressed():
		stored_keys = event.as_text().to_lower()
	if event.is_action_pressed("ui_cancel") && GState.is_typing():
		$Control/Close.pressed.emit()

func open_cmd():
	select_node()
	prompt_gen(get_tree().root.get_children()[-1])
	$Control.show()
	#<Change game state here>

func _ready() -> void:
	$Control.visible = false
	select_node()
	$Control/Back.pressed.connect(func():
		select_node()
		prompt_gen(back.pop_back())
		)
	$Control/Close.pressed.connect(func():
		$Control.visible = false
		promt_wipe()
		back.clear()
		#<Change game state here>
		)
	$Control/VBoxContainer2/Control/EditContainer/Node3DEdit/HBoxContainer/Move.pressed.connect(move)
	$Control/VBoxContainer2/Control/EditContainer/Node3DEdit/HBoxContainer2/Spin.pressed.connect(spin)

func _physics_process(delta: float) -> void:
	if $Control/VBoxContainer2/Control/EditContainer.visible && selected_node && selected_node is Node3D:
		set_edit()

func prompt_gen(par:Node):
	if !par: return
	promt_wipe()
	for i:Node in par.get_children():
		var h_box:HBoxContainer = HBoxContainer.new()
		var node:Button = Button.new()
		node.custom_minimum_size.x = $Control.custom_minimum_size.x*0.7
		node.custom_minimum_size.y = 50
		node.text = i.name
		node.pressed.connect(func():
			back.append(par)
			prompt_gen(i)
			)
		var edit_btn:Button = Button.new()
		edit_btn.custom_minimum_size.x = $Control.custom_minimum_size.x*0.3
		edit_btn.custom_minimum_size.y = 50
		edit_btn.text = "Edit"
		edit_btn.pressed.connect(func():
			back.append(par)
			edit_node(i)
			)
		h_box.add_child(node)
		h_box.add_child(edit_btn)
		$Control/VBoxContainer2/Control/ScrollContainer/Nodes.add_child(h_box)

func promt_wipe():
	for i in $Control/VBoxContainer2/Control/ScrollContainer/Nodes.get_children():
		i.queue_free()

func edit_node(node):
	selected_node = node
	set_edit()
	$Control/VBoxContainer2/Control/ScrollContainer.visible = false
	$Control/VBoxContainer2/Control/EditContainer.visible = true
	$Control/VBoxContainer2/Control/EditContainer/NodeName.text = node.name
	if node is Node3D:
		$Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer.visible = true
		$Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer2.visible = true
	else:
		$Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer.visible = false
		$Control/VBoxContainer2/Control/EditContainer/VBoxContainer2/HBoxContainer2.visible = false



func select_node():
	$Control/VBoxContainer2/Control/ScrollContainer.visible = true
	$Control/VBoxContainer2/Control/EditContainer.visible = false

func set_edit():
	pos_x.placeholder_text = "%s"%truncate(selected_node.global_position.x, 2)
	pos_y.placeholder_text = "%s"%truncate(selected_node.global_position.y, 2)
	pos_z.placeholder_text = "%s"%truncate(selected_node.global_position.z, 2)
	rot_x.placeholder_text = "%s"%truncate(rad_to_deg(selected_node.global_rotation.x), 2)
	rot_y.placeholder_text = "%s"%truncate(rad_to_deg(selected_node.global_rotation.y), 2)
	rot_z.placeholder_text = "%s"%truncate(rad_to_deg(selected_node.global_rotation.z), 2)

func truncate(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return int(value * factor) / factor
