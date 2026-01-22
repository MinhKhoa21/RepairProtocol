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

@export var ship_files:Array[ShipFile]
var selected_file:ShipFile

func _ready() -> void:
	accept.pressed.connect(func():
		Watcher.current_ship_file = selected_file
		close.pressed.emit()
		)
	deny.pressed.connect(func():
		pend(true)
		fetch_request()
		await get_tree().create_timer(1.5).timeout
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
	var rand_file:ShipFile = ship_files.pick_random()
	var img = rand_file.ship_img
	var ship = load(rand_file.ship_path).instantiate()
	ship_name.text = ship.ship_name
	ship_img_par.add_child(load(img).instantiate())
	ship.queue_free()
	selected_file = rand_file
