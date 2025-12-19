extends Resource
class_name Inventory

static var capacity:int = 20
static var slots:Array[Item]

static func inv_init():
	for i in capacity: slots.append(Item.new())
	#HotBar.select_item(0)

static func add_item(_item:Item):
	if slots.filter(func(x): return x.item_name == "").size() > 0:
		slots[slots.find_custom(func(x): return x.item_name == "")] = _item

static func swap_item(idx1:int, idx2:int):
	var temp = slots[idx1]
	slots[idx1] = slots[idx2]
	slots[idx2] = temp

static func is_empty(idx:int) -> bool: return slots[idx].item_name == ""
