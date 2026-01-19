extends Control
class_name ComponentInspectHud

@onready var i_con: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var item_1: HBoxContainer = $VBoxContainer/Item1
@onready var item_2: HBoxContainer = $VBoxContainer/Item2
@onready var ci1: ComponentImage = $VBoxContainer/Item1/ComponentImage
@onready var name_label1: Label = $VBoxContainer/Item1/VBoxContainer/ItemName
@onready var status_label1: Label = $VBoxContainer/Item1/VBoxContainer/ItemStatus
@onready var ci2: ComponentImage = $VBoxContainer/Item2/ComponentImage
@onready var name_label2: Label = $VBoxContainer/Item2/VBoxContainer/ItemName
@onready var status_label2: Label = $VBoxContainer/Item2/VBoxContainer/ItemStatus
var items:Array = []
const ar_item = 0 #Control
const ar_img = 1 #ComponentImage/Control
const ar_sev = 2 #Severity/int
const ar_name = 3 #ItemName/Label
const ar_status = 4 #ItemStatus/Label

func _ready() -> void:
	items.append([item_1, ci1, 0, name_label1, status_label1])
	items.append([item_2, ci2, 0, name_label2, status_label2])
	item_cache()
	Watcher.repaired.connect(func(x:RepairPoint):
		var item = mesh_to_item(x.highlight_meshes[0].mesh)
		if !item.is_empty():
			set_severity(item, x.severity)
		)
	Watcher.game_state_changed.connect(func():
		if !GState.is_idling():
			hide()
		else:
			show()
		)

func mesh_to_item(mesh:Mesh) -> Array:
	for i in items:
		if (i[ar_img] as ComponentImage).get_inspect_mesh() == mesh:
			return i
	return []

func add_item(mesh:Mesh, severity:int, _name:String):
	print("add_item called, severity: %s"%severity)
	if has_item(mesh): return
	if !can_add(severity): return
	var item = get_replace_item()
	(item[ar_img] as ComponentImage).set_item(mesh)
	set_severity(item, severity)
	item[ar_sev] = severity
	item[ar_name].text = _name

func is_empty() -> bool:
	for i in items:
		var j:ComponentImage = i[ar_img]
		if j.has_item(): return false
	return true

func get_replace_item():
	if is_empty(): return items[0]
	if has_slot(): for i in items: if !(i[ar_img] as ComponentImage).has_item(): return i
	if items[0][ar_sev] > items[1][ar_sev]: return items[1]
	else: return items[0]

func has_slot() -> bool:
	for i in items:
		if !i[ar_img].has_item(): return true
	return false

func item_cache():
	for i in items:
		remove_item(i)
	update()

func has_item(mesh:Mesh) -> bool:
	if is_empty(): return false
	return items.map(func(x): return (x[ar_img] as ComponentImage).get_inspect_mesh()).has(mesh)

func can_add(severity) -> bool:
	if is_empty() || has_slot(): return true
	for i in items:
		if severity >= i[ar_sev]: return true
	return false

func remove_item(item):
	(item[ar_img] as ComponentImage).remove_item()
	item[ar_sev] = 0
	item[ar_name].text = ""
	item[ar_status].text = ""

func update():
	for i in items:
		i[ar_item].visible = (i[ar_img] as ComponentImage).has_item()
	if items[0][ar_sev] < items[1][ar_sev]:
		var temp = items[0]
		items[0] = items[1]
		items[1] = temp

func set_severity(item, sev:int):
	match sev:
		2:
			item[ar_sev] = 2
			(item[ar_name] as Label).add_theme_color_override("font_color", Color(1, 0, 0, 1))
			(item[ar_status] as Label).add_theme_color_override("font_color", Color(1, 0, 0, 1))
			(item[ar_status] as Label).text = "Badly damaged."
		1:
			item[ar_sev] = 2
			(item[ar_name] as Label).add_theme_color_override("font_color", Color(1, 1, 0, 1))
			(item[ar_status] as Label).add_theme_color_override("font_color", Color(1, 1, 0, 1))
			(item[ar_status] as Label).text = "Damaged."
		_:
			item[ar_sev] = 2
			(item[ar_name] as Label).add_theme_color_override("font_color", Color(0, 1, 0, 1))
			(item[ar_status] as Label).add_theme_color_override("font_color", Color(0, 1, 0, 1))
			(item[ar_status] as Label).text = "Fine."
	update()
