extends Resource
class_name ArrayKit

static func cache(_arr:Array):
	var _size = _arr.size()
	_arr.clear()
	_arr.resize(_size)
