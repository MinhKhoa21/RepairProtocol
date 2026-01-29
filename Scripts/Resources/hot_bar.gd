extends Resource
class_name HotBar

static var hands:int = 6
static var slots:Array[Item] = [null, null, null, null, null, null]
static var heavy_item:HeavyItem2 = null
static var active_item:Item:
	set(val):
		active_item = val
		Watcher.hand_swapped.emit(slots.find(val))
static var active_name:StringName
static var active_idx:int = -1
static var active_slot:int = -1
#static var heavy_item:HItem
static func select(idx:int):
	if idx > hands: return
	if idx == active_idx || !slots[idx]:
		hand()
		return
	heavy_item = null
	active_idx = idx
	active_item = slots[idx]
	active_name = slots[idx].item_name

static func populate_hot_bar(_storage:Storage):
	#slots.clear()
	for i:int in range(hands):
		if _storage.slots: slots[i] = _storage.slots[i]
		print(_storage.slots[i])
	Watcher.hotbar_populated.emit()

static func hand():
	active_item = null
	heavy_item = null
	active_name = ""
	active_idx = -1

static func carry(_item:Item):
	active_item = null
	heavy_item = _item
	active_name = heavy_item.item_name
	active_idx = -2

static func drop_heavy():
	if heavy_item:
		heavy_item.drop()
		heavy_item = null
	
#static func pick_up(item:Item):
	#if item 

static func is_hammer() -> bool: return active_item && active_item.item_type == Item.item_enum.HAMMER
static func is_screwdriver() -> bool: return active_item && active_item.item_type == Item.item_enum.SCREWDRIVER
