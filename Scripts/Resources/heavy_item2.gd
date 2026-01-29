extends Item
class_name HeavyItem2

##Ridgid body of the item.
@export var rid:StringName

func drop():
	var item = load(rid).instantiate() as RigidBody3D
	
