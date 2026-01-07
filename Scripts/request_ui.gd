extends Control

@onready var accept: Button = $Control/ChoiceContainer/Accept
@onready var deny: Button = $Control/ChoiceContainer/Deny
@onready var close: Button = $Close
@onready var engine: Label = $Control/StatusContainer/Engine
@onready var energy_core: Label = $Control/StatusContainer/EnergyCore
@onready var hull: Label = $Control/StatusContainer/Hull
@onready var shield: Label = $Control/StatusContainer/Shield
@onready var type: Label = $Control/StatusContainer/Type
@onready var ship_name: Label = $Control/DemonstrateContainer/ShipName
@onready var ship_img_par: SubViewportContainer = $Control/DemonstrateContainer/SubViewportContainer
@onready var pending: Control = $Pending
@onready var not_pending: Control = $Control

@export var ship_img_path:Dictionary[StringName, StringName]
var selected_img

func _ready() -> void:
	accept.pressed.connect(func():
		Watcher.load_ship(ship_img_path[selected_img])
		close.pressed.emit()
		)
	deny.pressed.connect(func():
		pend(true)
		fetch_request()
		await get_tree().create_timer(randf_range(1, 3)).timeout
		pend(false)
		)
	deny.pressed.emit()

func pend(_bool:bool = true):
	if _bool:
		not_pending.hide()
		pending.show()
		$PanelContainer2.hide()
		$PanelContainer3.hide()
		$PanelContainer4.hide()
	else:
		not_pending.show()
		pending.hide()
		$PanelContainer2.show()
		$PanelContainer3.show()
		$PanelContainer4.show()

func fetch_request():
	for i in ship_img_par.get_children(): i.queue_free()
	var img = ship_img_path.keys().pick_random()
	var ship = load(ship_img_path[img]).instantiate() as Vehicle
	ship_name.text = ship.ship_name
	ship.queue_free()
	ship_img_par.add_child(load(img).instantiate())
	selected_img = img
