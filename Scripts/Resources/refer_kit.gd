extends Resource
class_name ReferKit

static var var_holder:Dictionary[String, Variant]
static var res_holder:Array[Resource]

static func wipe(): #Called for resource deactivation.
	for i in res_holder:
		i.active = false
		i.res_wipe

static func generate_node(path:StringName) -> Node:
	return load(path).instantiate

static func tally(_node:Node, flag:String = ""):
	_node.set_meta(flag, "")

static func extinct(_tree:Node, flag:String = ""):
	for i:Node in _tree.get_children(true):
		if i.has_meta(flag):
			i.queue_free()

static func retrieve(flag:String) -> Variant:
	if var_holder.find_key(flag) == null:
		return null
	return var_holder[flag]

##For quick variable converter without creating a dictionary
static func flow(variable:Variant, within:Array, to:Array) -> Variant:
	if within.size() > to.size(): return null
	return to[within.find(variable)]

static func find_type(arr:Array, class_type:StringName):
	return arr.filter(func(x): return x.get_class() == class_type)[0]
