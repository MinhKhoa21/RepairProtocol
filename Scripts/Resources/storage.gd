extends Resource
class_name Storage

@export var capacity:int = 10
@export var slots:Array[Item] = []

#func _init(_capacity:int) -> void:
	#capacity = _capacity
	#slots.resize(capacity)

func add_item(_item:Item):
	slots.append(_item)

func remove_item(_item:Item):
	slots.erase(_item)
