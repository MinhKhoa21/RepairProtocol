@abstract
extends Resource
class_name CResource #Custom Resource

var referer:Node #The node resource belongs to upon init.

func _init(_node:Node) -> void:
	referer = _node

var active:bool = true
@abstract func deactivate() #All resource variable will be set to null upon call
