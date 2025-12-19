extends Node

signal game_state_changed(_int:int)
var game_state_watcher:int = 0:
	set(val):
		if val != game_state_watcher: game_state_changed.emit(val)
		game_state_watcher = val

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if GState.is_playing(): GState.pause()
		else: GState.play()
	
	if event.is_action_pressed("slot1"):
		HotBar.select(0)
	if event.is_action_pressed("slot2"):
		HotBar.select(1)
	if event.is_action_pressed("slot3"):
		HotBar.select(2)
	if event.is_action_pressed("slot4"):
		HotBar.select(3)
	if event.is_action_pressed("slot5"):
		HotBar.select(4)

func _ready() -> void:
	Inventory.inv_init()
	Inventory.add_item(Tool.new(ItemNames.wrench))
	#print(Inventory.slots.map(func(x): return x.item_name))

func _process(delta: float) -> void:
	game_state_watcher = GState.game_state
	match GState.game_state:
		GState.gstate_enum.PLAYING:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		GState.gstate_enum.INSPECTING:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
