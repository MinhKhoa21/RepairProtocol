extends Node

enum root_enum {
	NONE,
	MAIN_MENU,
	GARAGE
}

var game_state_watcher:int = 0:
	set(val):
		if val != game_state_watcher: game_state_changed.emit()
		game_state_watcher = val
signal game_state_changed(_int:int)
signal action_ended
signal hand_swapped(_item:Item)
signal cargo_assigned
signal scan_hit(part_name: String)
signal scan_cleared()
signal ship_changed
signal repaired(rp)
signal save_progress
signal back

var total_game_time:float = 11*3600
var total_real_time:float = 5*60
var head_start_time:float = 6*3600
var elapsed_real_time:float = 0
var elapsed_game_time:float = 0
@onready var time_scale = total_game_time/total_real_time

const a_hour = 0
const a_minute = 1
const a_second = 2
const hour_cap = 23
const minute_cap = 59
const second_cap = 59
var ui_playtime:int = 1700
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
var level:Level
var player_cam:Camera3D
var input_hud:Array[Control]
var scanned_parts: Array[String] = []
var queued_scene:StringName
var garage:Node3D
var player_hud
var current_ship_file:ShipFile:
	set(val):
		current_ship_file = val
		if val:
			load_hologram(val.ship_hologram)
			load_ship(val.ship_path)
var current_ship:Vehicle:
	set(val):
		current_ship = val
		ship_changed.emit()
var current_hologram:ShipHologram
var current_root:int
var warning_color:Dictionary = {
	"good": Color(0, 1, 0, 1),
	"not_good": Color(1, 1, 0, 1),
	"bad": Color(1, 0, 0, 1)
}
var hp:HologramProjector

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	GState.play()
	#Inventory.add_item(Tool.new(ItemNames.wrench))
	hand_swapped.connect(func(item:Item):
		tool_cache()
		if item is Tool:
			var item_node:Node = (item as Tool).packed_scene.instantiate()
			right_hand.add_child(item_node)
			tool_nodes.append(item_node)
		)
	game_state_changed.connect(func():
		get_tree().paused = GState.is_paused() || GState.is_settings()
		if GState.is_idling() && GState.is_playing():
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		)
		
	repaired.connect(func(x): hologram_update())
	back.connect(cancel)

func _process(delta: float) -> void:
	if !get_tree().paused: update_playtime(delta)
	game_state_watcher = GState.game_state + GState.player_state
	#update_game_state()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		back.emit()
	
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

func tool_cache():
	for i in tool_nodes:
		i.queue_free()
		tool_nodes.erase(i)
	#print("tool cache called", tool_nodes)

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
	current_root = root_enum.NONE
	get_tree().change_scene_to_file("res://Scenes/loading.tscn")

func load_ship(path:StringName):
	var ship = load(path).instantiate()
	current_ship = ship
	#garage.get_node("ShipNode").add_child(ship)
	garage.perform_landing()

func load_hologram(path:StringName):
	var hol = load(path).instantiate()
	current_hologram = hol

func hologram_update():
	for i:RepairPoint in current_ship.repair_point.filter(func(x): return x.scanned):
		for j:MeshInstance3D in i.highlight_meshes:
			current_hologram.set_override_color(j, (i as RepairPoint).severity)
			var ci_hud:ComponentInspectHud = player_hud.get_children().filter(func(x): return x is ComponentInspectHud)[0]
			ci_hud.add_item(j.mesh, i.severity, j.name)

func remove_ship():
	current_ship = null
	current_hologram = null
	current_ship_file = null
	var ci_hud : ComponentInspectHud = player_hud.get_children().filter(func(x): return x is ComponentInspectHud)[0]
	ci_hud.item_cache()

func update_playtime(delta):
	if !GState.is_playing(): return
	if elapsed_real_time < total_real_time:
		elapsed_real_time += delta
		elapsed_game_time = elapsed_real_time*time_scale + head_start_time

func get_clock(includes_seconds:bool = true) -> String:
	var hours = int(elapsed_game_time/3600) % 24
	var minutes = int(elapsed_game_time/60) % 60
	var seconds = int(elapsed_game_time) % 60
	if includes_seconds: return "%02d:%02d:%02d"%[hours, minutes, seconds]
	return "%02d:%02d"%[hours, minutes]

func get_time_progress() -> float:
	return elapsed_real_time/total_real_time

func start_game():
	elapsed_game_time = 0
	elapsed_real_time = 0

func cancel():
	if is_main_menu():
		if !GState.is_none(): GState.none()
	if is_garage():
		if !GState.is_idling(): GState.idle()
		else:
			if !GState.is_paused(): GState.pause()
			else: GState.play()

func is_main_menu() -> bool: return current_root == root_enum.MAIN_MENU
func is_garage() -> bool: return current_root == root_enum.GARAGE
