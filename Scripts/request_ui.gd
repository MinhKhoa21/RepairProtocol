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

@export var ship_path_img:Dictionary[StringName, StringName]

var request:Array = [] #[ship_image:StringName, ship_path:StringName]

func _ready() -> void:
	accept.pressed.connect(func():
		Watcher.load_ship("res://model/Ship/shipver_2.tscn")
		close.pressed.emit()
		)
	deny.pressed.connect(func():
		pend(true)
		for i in ship_img_par.get_children(): i.queue_free()
		ship_img_par.add_child(load(ship_path_img[ship_path_img.keys().pick_random()]).instantiate())
		await get_tree().create_timer(randf_range(2, 4)).timeout
		pend(false)
		)

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
