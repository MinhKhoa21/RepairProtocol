extends Resource
class_name HotBar

static var hands:int = 5
static var slots:Array[Item] = [null, null, null, null, null]
static var heavy_item:Item = null
static var active_item:Item:
	set(val):
		active_item = val
		Watcher.hand_swapped.emit(val)
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
