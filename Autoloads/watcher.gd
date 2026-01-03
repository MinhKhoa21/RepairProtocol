extends Node

var game_state_watcher:int = 0:
	set(val):
		if val != game_state_watcher: game_state_changed.emit(val)
		game_state_watcher = val
signal game_state_changed(_int:int)
signal action_ended
signal hand_swapped(_item:Item)
signal cargo_assigned
signal scan_hit(part_name: String)
signal scan_cleared()


var cargo:Array:
	set = set_cargo
func set_cargo(a):
	cargo = a
	cargo_assigned.emit()
var right_hand:Node3D
var carry:Node3D
var player:Player
var player_ani_remaining_dur:float
var tool_nodes:Array[Node] = []
var current_ship:Vehicle
var ship_in_queue:Array[Vehicle]
var level:Level
var player_cam:Camera3D
var input_hud:Array[Control]
var scanned_parts: Array[String] = []
var queued_scene:StringName
var garage:Node3D


func _ready() -> void:
	GState.play()
	#Inventory.add_item(Tool.new(ItemNames.wrench))
	hand_swapped.connect(func(item:Item):
		tool_cache()
		if item is Tool:
			var item_node:Node = (item as Tool).packed_scene.instantiate()
			right_hand.add_child(item_node)
			tool_nodes.append(item_node)
		)

func _process(delta: float) -> void:
	game_state_watcher = GState.game_state
	update_game_state()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if GState.is_playing(): GState.pause()
		else: GState.play()
	
	if GState.is_playing():
		if event.is_action_pressed("slot1"):
			HotBar.select(0)
			hand_swapped.emit()
		if event.is_action_pressed("slot2"):
			HotBar.select(1)
			hand_swapped.emit()
		if event.is_action_pressed("slot3"):
			HotBar.select(2)
			hand_swapped.emit()
		if event.is_action_pressed("slot4"):
			HotBar.select(3)
			hand_swapped.emit()
		if event.is_action_pressed("slot5"):
			HotBar.select(4)
			hand_swapped.emit()

func update_game_state():
	match GState.game_state:
		GState.gstate_enum.PLAYING:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func tool_cache():
	for i in tool_nodes:
		i.queue_free()
		tool_nodes.erase(i)
	#print("tool cache called", tool_nodes)

func start_game():
	pass

func absolute_focus(control:Control):
	if !input_hud.has(control):
		input_hud.append(control)
	for i:Control in input_hud:
		if i != control: i.mouse_filter = Control.MOUSE_FILTER_IGNORE

func neutralize_control():
	for i:Control in input_hud:
		i.mouse_filter = Control.MOUSE_FILTER_STOP

func register_scan(part_name: String):
	if not scanned_parts.has(part_name):
		scanned_parts.append(part_name)
		print("Data scan saved: ", part_name)

func change_scene(path:StringName):
	queued_scene = path
	get_tree().change_scene_to_file("res://Scenes/loading.tscn")

func load_ship(path:StringName):
	var ship = load(path).instantiate()
	current_ship = ship
	#garage.get_node("ShipNode").add_child(ship)
	garage.perform_landing()
